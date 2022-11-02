//
//  VC_TransferMoney.swift
//  iBank
//
//  Created by Keval on 3/26/21.
//

import UIKit

class TransferMoneyViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvAccountList: UITableView!
    @IBOutlet weak var constraint_tvAccList_height: NSLayoutConstraint!
    @IBOutlet weak var picker_payee: UIPickerView!
    @IBOutlet weak var fieldAmount: UITextField!
    @IBOutlet weak var btnTransfer: UIButton!
    
    // variables
    var accounts = [BankAccount]()
    
    var allCustomers = [CustomerDetails]()
    var allCustomerNames = [String]()
    var selectedCustomerAccounts = [String]()
    var payeeAccNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let customer = Constants.loggedInCustomer {
            setBankAccounts(customer: customer)
        }
        else {
            print("Error:- loggedInCustomer is nil")
        }
        
        // filling allCustomers
        if let allCusts = Constants.customers {
            allCustomers = allCusts.customers
            for cust in allCustomers {
                allCustomerNames.append(cust.name)
            }
        }
        
            
        tvAccountList.delegate = self
        tvAccountList.dataSource = self
        tvAccountList.tableFooterView = UIView()
        constraint_tvAccList_height.constant = CGFloat(accounts.count * 88)
        
        picker_payee.delegate = self
        picker_payee.dataSource = self
        // picker_payee.selectRow(0, inComponent: 0, animated: true)
        pickerView(picker_payee, didSelectRow: 0, inComponent: 0)
        
        btnTransfer.layer.cornerRadius = CGFloat(12)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UI actions
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeTransfer(_ sender: Any) {
        if shouldTransfer() {
            let amount = Double(fieldAmount.text!)!
            BankTransationService.shared.addToBeneficiary(money: amount, accToTransfer: payeeAccNo)
            let acc = accounts[tvAccountList.indexPathForSelectedRow!.row]
            _ = acc.deductBalance(amountToDeduct: amount)
            
            Constants.updateData()
            
            self.showAlertPopup(title: "Success", message: "$ \(amount) transfered successfully!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{(action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }])
        }
    }
    
    
    // MARK: - helper functions
    
    func setBankAccounts(customer: CustomerDetails) {
        accounts = [BankAccount]()
        
        if let _accounts = customer.accounts {
            if let savingAcc = _accounts.savingsAcc {
                accounts.append(savingAcc)
            }
            
            if let salaryAcc = _accounts.salaryAcc {
                accounts.append(salaryAcc)
            }
            
            if let fdAcc = _accounts.fixedDepositAcc {
                accounts.append(fdAcc)
            }
        }
    }
    
    func shouldTransfer() -> Bool {
        var transferAmount = Double(0)
        var availableBalance = Double(0)
        
        // check for amount related errors
        if let amountText = fieldAmount.text {
            if let amount = Double(amountText)  {
                transferAmount = amount
            }
            else {
                self.showCustomToast(message: "enter valid amount", font: UIFont.myFont())
                return false
            }
        }
        else {
            self.showCustomToast(message: "enter amount", font: UIFont.myFont())
            return false
        }
        
        // check for entered amount should exist in the selected account
        if let fromAcc = tvAccountList.indexPathForSelectedRow {
            switch fromAcc.row {
                case 0: // saving
                availableBalance = Constants.loggedInCustomer!.accounts!.savingsAcc!.accountBalance
                    
                case 1: // salary
                availableBalance = Constants.loggedInCustomer!.accounts!.salaryAcc!.accountBalance
                    
                case 2: // fixed deposit
                availableBalance = Constants.loggedInCustomer!.accounts!.fixedDepositAcc!.accountBalance
                    
                default:
                    print("Error")
            }
            
            if transferAmount <= availableBalance {
                // process the transaction
                return true
            }
            else {  // error
                self.showAlertPopup(title: "Oops", message: "You don not have sufficient balance in selected account", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
                
                return false
            }
            
        }
        else {  // no bank account selected from which to transfer
            self.showAlertPopup(title: "Oops", message: "Please select one of your bank account from the list to make the transfer!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
            return false
        }
    }

}

extension TransferMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acc = accounts[indexPath.row]
        let cell = tvAccountList.dequeueReusableCell(withIdentifier: "TVcell_AccountList") as! AccountListTableCell
        
        cell.setCell(accType: acc is SavingsAccount ? "Saving Account" : (acc is SalaryAccount ? "Salary Account" : (acc is FixedDepositAccount ? "Fixed Deposit Account" : "")), accBalance: acc.accountBalance)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // code to act on account selection change
    }
    
}

extension TransferMoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return allCustomerNames.count
        }
        else {
            return selectedCustomerAccounts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return allCustomerNames[row]
        }
        else {
            return selectedCustomerAccounts[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // payee name selected
            let selectedCustomer = allCustomers.first { (customer) -> Bool in
                customer.name.lowercased() == allCustomerNames[row].lowercased()
            }
            
            selectedCustomerAccounts = [String]()
            if let cust = selectedCustomer {
                if let saving = cust.accounts?.savingsAcc {
                    selectedCustomerAccounts.append("saving acc (\(saving.accountNo))")
                }
                if let salary = cust.accounts?.salaryAcc {
                    selectedCustomerAccounts.append("salary acc (\(salary.accountNo))")
                }
                if let fd = cust.accounts?.fixedDepositAcc {
                    selectedCustomerAccounts.append("fd acc (\(fd.accountNo))")
                }
            }
            
            picker_payee.reloadComponent(1)
            // picker_payee.selectRow(0, inComponent: 1, animated: true)
            self.picker_payee.delegate?.pickerView?(self.picker_payee, didSelectRow: 0, inComponent: 1)
        }
        else {
            // payee account selected
            payeeAccNo = String((selectedCustomerAccounts[row].split(separator: "(")[1]).split(separator: ")")[0])
            print(payeeAccNo)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Chalkboard SE", size: 20)
        label.text = component == 0 ? allCustomerNames[row] : selectedCustomerAccounts[row]
        label.textAlignment = .center
        label.layoutMargins = UIEdgeInsets(top: CGFloat(0), left: CGFloat(10), bottom: CGFloat(0), right: CGFloat(10))
        return label
    }
    
}

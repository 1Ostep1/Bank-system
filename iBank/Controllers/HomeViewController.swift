//
//  HomeViewController.swift
//  iBank
//
//  Created by Keval on 3/24/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var label_helloGuest: UILabel!
    @IBOutlet weak var tvAccountList: UITableView!
    @IBOutlet weak var constraint_tvAccList_height: NSLayoutConstraint!
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var deposit_view: UIView!
    @IBOutlet weak var withdraw_view: UIView!
    @IBOutlet weak var transfer_view: UIView!
    @IBOutlet weak var payBill_view: UIView!
    @IBOutlet weak var addAcc_view: UIView!
    @IBOutlet weak var editProfile_view: UIView!
    // @IBOutlet weak var transactions_view: UIView!
    
    var accounts = [BankAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        // Do any additional setup after loading the view.
        
        if let customer = Constants.loggedInCustomer {
            label_helloGuest.text = "Hello \(Constants.loggedInCustomer!.name),\nWelcome back to iBank!"
            
            setBankAccounts(customer: customer)
        }
        else {
            print("Error:- loggedInCustomer is nil")
        }
        
        tvAccountList.delegate = self
        tvAccountList.dataSource = self
        tvAccountList.tableFooterView = UIView()
        
        constraint_tvAccList_height.constant = CGFloat(accounts.count * 88)
        
        // adding tap gesture to all transactions UIView
        
        deposit_view.addTapGesture(action: onDepositClick)
        withdraw_view.addTapGesture(action: onWithdrawClicked)
        transfer_view.addTapGesture(action: onTransferClicked)
        payBill_view.addTapGesture(action: onPayBillClicked)
        addAcc_view.addTapGesture(action: onAddAccClicked)
        editProfile_view.addTapGesture(action: onEditProfileClicked)
        // transactions_view.addTapGesture(action: onTransactionsClicked)
        
    }
    
    // this function will be called everytime a ViewController will appear on screen
    // So, we can use this function to check any updates to process on screen like updating the bank account table view and like that
    override func viewDidAppear(_ animated: Bool) {
        if let customer = Constants.loggedInCustomer {
            setBankAccounts(customer: customer)
            tvAccountList.reloadData()
            constraint_tvAccList_height.constant = CGFloat(accounts.count * 88)
        }
        else {
            print("Error:- loggedInCustomer is nil")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - UI actions

    @IBAction func goBack(_ sender: Any) {
        showAlertPopup(title: "Confirmation", message: "Going back will log you out. Are you sure you want to log out?", alertStyle: .alert, actionTitles: ["Cancel", "Logout"], actionStyles: [.cancel, .destructive], actions: [dismissAlert(action:), alertActionLogout(action:)])
    }
    
    @IBAction func logout(_ sender: Any) {
        showAlertPopup(title: "Confirmation", message: "Are you sure you want to log out?", alertStyle: .alert, actionTitles: ["Cancel", "Logout"], actionStyles: [.cancel, .destructive], actions: [dismissAlert(action:), alertActionLogout(action:)])
    }
    
    
    // MARK: - functions for Transactions
    
    func onDepositClick() {
        
        if let selectedRow = tvAccountList.indexPathForSelectedRow {
            let acc = accounts[selectedRow.row]
            showDepositPopup(acc: acc)
        }
        else {
            showAlertPopup(title: "Oops", message: "Please select any account from your account list, to deposit money in that account!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
        }
        
    }
    
    func onWithdrawClicked() {
        
        if let selectedRow = tvAccountList.indexPathForSelectedRow {
            let acc = accounts[selectedRow.row]
            showWithdrawPopup(acc: acc)
        }
        else {
            showAlertPopup(title: "Oops", message: "Please select any account from your account list, to withdraw money from that account!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
        }
        
    }
    
    func onTransferClicked() {
        performSegue(withIdentifier: "segue_transferMoney", sender: self)
    }
    
    func onPayBillClicked() {
        
    }
    
    func onAddAccClicked() {
        performSegue(withIdentifier: "segue_addBankAcc", sender: self)
    }
    
    func onEditProfileClicked() {
        performSegue(withIdentifier: "segue_editProfile", sender: self)
    }
    
    func onTransactionsClicked() {
        
    }
    
    
    // MARK: - Helper functions
    
    func dismissAlert(action: UIAlertAction) {
        // do nothing to just dismiss the alert
    }
    
    func alertActionLogout(action: UIAlertAction) {
        performLogout()
    }
    
    func performLogout() {
        Constants.loggedInCustomer = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func showDepositPopup(acc: BankAccount) {
        var depositAmountTextField: UITextField?
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Deposit Money", message: "Please enter the amount you want to deposit!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Deposit", style: .destructive, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let userInput = depositAmountTextField!.text {
                print("User entered \(userInput)")
                
                if !userInput.isEmpty {
                    if let amount = Double(userInput) {
                        _ = acc.addBalance(amountToAdd: amount)
                        Constants.updateData()
                        self.tvAccountList.reloadData()
                        
                        self.showCustomToast(message: "Success!", font: UIFont.myFont())
                    }
                    else {
                        self.showCustomToast(message: "Enter valid amount", font: UIFont.myFont())
                    }
                }
                else {
                    self.showCustomToast(message: "enter amount", font: UIFont.myFont())
                }
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Add Input TextField to dialog message
        dialogMessage.addTextField { (textField) -> Void in
            
            depositAmountTextField = textField
            depositAmountTextField?.placeholder = "Enter amount to add"
        }
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showWithdrawPopup(acc: BankAccount) {
        var withdrawAmountTextField: UITextField?
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Withdraw Money", message: "Please enter the amount you want to withdraw!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Withdraw", style: .destructive, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let userInput = withdrawAmountTextField!.text {
                print("User entered \(userInput)")
                
                if !userInput.isEmpty {
                    if let amount = Double(userInput) {
                        if amount < acc.accountBalance {
                            _ = acc.deductBalance(amountToDeduct: amount)
                            Constants.updateData()
                            self.tvAccountList.reloadData()
                            
                            self.showCustomToast(message: "Success!", font: UIFont.myFont())
                        }
                        else {
                            self.showAlertPopup(title: "Oops", message: "Entered amount is more than existing account balance!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
                        }
                        
                    }
                    else {
                        self.showCustomToast(message: "Enter valid amount", font: UIFont.myFont())
                    }
                }
                else {
                    self.showCustomToast(message: "enter amount", font: UIFont.myFont())
                }
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Add Input TextField to dialog message
        dialogMessage.addTextField { (textField) -> Void in
            
            withdrawAmountTextField = textField
            withdrawAmountTextField?.placeholder = "Enter amount to add"
        }
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
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
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acc = accounts[indexPath.row]
        let cell = tvAccountList.dequeueReusableCell(withIdentifier: "TVcell_AccountList") as! AccountListTableCell
        
        cell.setCell(accType: acc is SavingsAccount ?
                     "Saving Account" :
                        (acc is SalaryAccount ? "Salary Account" :
                            (acc is FixedDepositAccount ?
                             "Fixed Deposit Account" : "")),
                     accBalance: acc.accountBalance)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform action on account row selection
    }  
}

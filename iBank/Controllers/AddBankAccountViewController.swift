//
//  AddBankAccountViewController.swift
//  iBank
//
//  Created by Keval on 3/26/21.
//

import UIKit

class AddBankAccountViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var picker_accType: UIPickerView!
    
    @IBOutlet weak var view_savingAcc: UIView!
    @IBOutlet weak var savingField_amount: UITextField!
    @IBOutlet weak var savingLabel_minAmount: UILabel!
    @IBOutlet weak var savingLabel_intRate: UILabel!
    
    @IBOutlet weak var view_salaryAcc: UIView!
    @IBOutlet weak var salaryField_amount: UITextField!
    @IBOutlet weak var salaryField_employer: UITextField!
    @IBOutlet weak var salaryField_salary: UITextField!
    
    @IBOutlet weak var view_fdAcc: UIView!
    @IBOutlet weak var fdField_amount: UITextField!
    @IBOutlet weak var fdField_months: UITextField!
    @IBOutlet weak var fdLabel_intRate: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    // Variables
    var accTypes = ["Saving Account", "Salary Account", "Fixed Deposit Account"]
    var accounts: Accounts?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker_accType.delegate = self
        picker_accType.dataSource = self
        
        pickerView(picker_accType, didSelectRow: 0, inComponent: 0)
        
        if let cust = Constants.loggedInCustomer {
            if let accs = cust.accounts {
                accounts = accs
            }
            else {
                print("Error - accounts of loggedInCustomer is nil")
            }
        }
        else {
            print("Error - loggedInCustomer is nil")
        }
        
        btnSubmit.layer.cornerRadius = CGFloat(12)
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
    
    @IBAction func onSubmit(_ sender: Any) {
        
        if shouldAddAccount() {
            
            if let acc = addAccount() {
                if acc is SavingsAccount {
                    accounts?.savingsAcc = acc as? SavingsAccount
                }
                else if acc is SalaryAccount {
                    accounts?.salaryAcc = acc as? SalaryAccount
                }
                else if acc is FixedDepositAccount {
                    accounts?.fixedDepositAcc = acc as? FixedDepositAccount
                }
            }
            
            if let bankAccs = self.accounts {
                Constants.loggedInCustomer!.addBankAccounts(accs: bankAccs)
            }
            
            // update the data saved in file
            Constants.updateData()
            
            showAlertPopup(title: "Success", message: "Bank account added successfully!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{(action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }])
            
        }
        
    }
    
    
    // MARK: - helper functions
    
    func addAccount() -> BankAccount? {
        var account: BankAccount?
        
        switch picker_accType.selectedRow(inComponent: 0) {
            case 0: // saving account
                account = SavingsAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                         accBalance: Double(savingField_amount.text!)!,
                                         minBal: Constants.savingMinBal,
                                         intRate: Constants.savingIntRate)
                
            case 1: // salary account
                account = SalaryAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                        accBalance: Double(salaryField_amount.text!)!,
                                        employer: salaryField_employer.text!,
                                        monthlySalary: Double(salaryField_salary.text!)!)
                
            case 2:
                account = FixedDepositAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                              accBalance: Double(fdField_amount.text!)!,
                                              termDur: Int(fdField_months.text!)!,
                                              intRate: Constants.fdIntRate)
                
            default:
                print("Error - no row selected for pickerview")
        }
        
        return account
    }
    
    func shouldAddAccount() -> Bool {
        
        switch picker_accType.selectedRow(inComponent: 0) {
            case 0: // saving account
                if let amount = savingField_amount.text {
                    if !amount.isEmpty {
                        return true
                    }
                }
                print("")
                
            case 1: // salary account
                if let amount = salaryField_amount.text {
                    if !amount.isEmpty {
                        return true
                    }
                }
                print("")
                
            case 2: // fixed deposit account
                if let amount = fdField_amount.text {
                    if !amount.isEmpty {
                        if let months = fdField_months.text {
                            if !months.isEmpty {
                                return true
                            }
                        }
                    }
                }
                print("")
                
            default:
                print("Error")
        }
        
        return false
    }
    
}

extension AddBankAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        accTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        accTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
            case 0:
                view_savingAcc.isHidden = false
                view_salaryAcc.isHidden = true
                view_fdAcc.isHidden = true
                
            savingLabel_minAmount.text = "$ \(String(Constants.savingMinBal))"
            savingLabel_intRate.text = "\(String(Constants.savingIntRate)) %"
                
            case 1:
                view_savingAcc.isHidden = true
                view_salaryAcc.isHidden = false
                view_fdAcc.isHidden = true
                
            case 2:
                view_savingAcc.isHidden = true
                view_salaryAcc.isHidden = true
                view_fdAcc.isHidden = false
                
            fdLabel_intRate.text = "\(String(Constants.fdIntRate)) %"
                
            default:
                view_savingAcc.isHidden = true
                view_salaryAcc.isHidden = true
                view_fdAcc.isHidden = true
        }
    }
    
}

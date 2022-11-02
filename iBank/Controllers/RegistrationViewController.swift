//
//  RegistrationViewController.swift
//  iBank
//
//  Created by Keval on 3/24/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var scrollView_main: UIScrollView!
    
    @IBOutlet weak var field_name: UITextField!
    @IBOutlet weak var field_password: UITextField!
    @IBOutlet weak var segment_gender: UISegmentedControl!
    @IBOutlet weak var field_contact: UITextField!
    @IBOutlet weak var field_address: UITextField!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker_accType.delegate = self
        picker_accType.dataSource = self
        
        pickerView(picker_accType, didSelectRow: 0, inComponent: 0)
        // scrollView_main.scrollsToTop = true
        
        btnSubmit.layer.cornerRadius = CGFloat(12)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UI Actions
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        if shouldSubmit() {
            
            let customer = CustomerDetails(name: field_name.text!, contactNo: field_contact.text!, address: field_address.text!, password: field_password.text!, gender: segment_gender.selectedSegmentIndex == 0 ? "male" : "female")
            
            switch picker_accType.selectedRow(inComponent: 0) {
                case 0: // saving account
                customer.addBankAccounts(accs: Accounts(salAcc: nil,
                                                        savAcc: SavingsAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                                                               accBalance: Double(savingField_amount.text!)!,
                                                                               minBal: Constants.savingMinBal,
                                                                               intRate: Constants.savingIntRate),
                                                        fixAcc: nil))
                    print("")
                    
                case 1: // salary account
                    customer.addBankAccounts(accs: Accounts(salAcc: SalaryAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                                                                  accBalance: Double(salaryField_amount.text!)!,
                                                                                  employer: salaryField_employer.text!,
                                                                                  monthlySalary: Double(salaryField_salary.text!)!),
                                                            savAcc: nil,
                                                            fixAcc: nil))
                    print("")
                    
                case 2: // Fd account
                    customer.addBankAccounts(accs: Accounts(salAcc: nil,
                                                            savAcc: nil,
                                                            fixAcc: FixedDepositAccount(accNo: AuthorizationService.shared.generateAccountNumber(),
                                                                                        accBalance: Double(fdField_amount.text!)!,
                                                                                        termDur: Int(fdField_months.text!)!,
                                                                                        intRate: Constants.fdIntRate)
                                                           ))
                    print("")
                    
                default:
                    print("Error")
            }
            
            // create the object of Customers which holds all data of our program
            if let custs = Constants.customers {
                custs.customers.append(customer)
                Constants.customers = custs
            }
            else {
                Constants.customers = Customers(custs: [customer])
            }
            
            var jsonStr = ""
            
            // if customers obj is not nil, get the JSONstring for that object
            if let data = Constants.customers {
                jsonStr = getJsonString(of: data)
            }
            
            // save Json string into file
            saveJsonFile(of: jsonStr)
            
            showAlertPopup(title: "Success", message: "Customer registration successfull.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{(action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }])
            
        }
    }
    
    // MARK: - Helper functions
    
    func shouldSubmit() -> Bool {
        if let name = field_name.text {
            if !name.isEmpty {
                if let pass = field_password.text {
                    if !pass.isEmpty {
                        
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
                        
                    }
                }
            }
        }
        
        return false
    }
    

}

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accTypes.count
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

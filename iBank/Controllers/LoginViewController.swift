//
//  LoginViewController.swift
//  iBank
//
//  Created by Keval on 3/24/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fieldName.becomeFirstResponder()
        btnLogin.layer.cornerRadius = CGFloat(12)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fieldName.becomeFirstResponder()
        btnLogin.layer.cornerRadius = CGFloat(12)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UI actions
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        if let name = fieldName.text {
            if !name.isEmpty {
                if let pass = fieldPassword.text {
                    if !pass.isEmpty {
                        Constants.loggedInCustomer = AuthorizationService.shared.tryLogin(name: name, pass: pass)
                        if Constants.loggedInCustomer == nil {
                            showAlertPopup(title: "Uh-oh", message: "name and password doesn't match OR the user not found", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
                        }
                        else {
                            // showCustomToast(message: "Login Success!", font: UIFont.myFont())
                            
                            fieldName.text = ""
                            fieldPassword.text = ""
                            fieldName.becomeFirstResponder()
                            performSegue(withIdentifier: "segue_homeScreen", sender: self)
                        }
                    }
                    else{
                        showCustomToast(message: "Password empty!", font: UIFont.myFont())
                    }
                }
            }
            else{
                showCustomToast(message: "Username empty!", font: UIFont.myFont())
            }
        }
        
    }
    

}

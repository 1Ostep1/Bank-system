//
//  EditProfileViewController.swift
//  iBank
//
//  Created by Keval on 3/27/21.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var field_name: UITextField!
    @IBOutlet weak var field_password: UITextField!
    @IBOutlet weak var segment_gender: UISegmentedControl!
    @IBOutlet weak var field_contact: UITextField!
    @IBOutlet weak var field_address: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = Constants.loggedInCustomer {
            field_name.text = user.name
            field_password.text = user.password
            segment_gender.selectedSegmentIndex = user.gender == "male" ? 0 : 1
            field_contact.text = user.contactNo
            field_address.text = user.address
        }
        
        btnUpdate.layer.cornerRadius = CGFloat(12)
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
    
    @IBAction func onUpdate(_ sender: Any) {
        if let _name = field_name.text {
            if !_name.isEmpty {
                if let _pass = field_password.text {
                    if !_pass.isEmpty {
                        Constants.loggedInCustomer?.name = _name
                        Constants.loggedInCustomer?.password = _pass
                        Constants.loggedInCustomer?.gender = segment_gender.selectedSegmentIndex == 0 ? "male" : "female"
                        Constants.loggedInCustomer?.contactNo = field_contact.text ?? ""
                        Constants.loggedInCustomer?.address = field_address.text ?? ""
                        
                        Constants.updateData()
                        showAlertPopup(title: "Success", message: "Profile updated successfully!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{(action) -> Void in
                            self.dismiss(animated: true, completion: nil)
                        }])
                    }
                    else {
                        showCustomToast(message: "password empty", font: UIFont.myFont())
                    }
                }
                else {
                    showCustomToast(message: "password empty", font: UIFont.myFont())
                }
            }
            else {
                showCustomToast(message: "empty name", font: UIFont.myFont())
            }
        }
        else {
            showCustomToast(message: "empty name", font: UIFont.myFont())
        }
    }
}

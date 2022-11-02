//
//  SplashViewController.swift
//  iBank
//
//  Created by Keval on 3/14/21.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAutoFill: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showRegister(_ sender: Any) {
        performSegue(withIdentifier: "segue_registration", sender: self)
    }
    
    @IBAction func showLogin(_ sender: Any) {
        performSegue(withIdentifier: "segue_login", sender: self)
    }
    
}


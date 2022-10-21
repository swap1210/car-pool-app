//
//  LoginVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 10/20/22.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Login"
    }
    
    
    @IBAction func verifyLogin(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "loginSuccess", sender: self)
    }
    
}

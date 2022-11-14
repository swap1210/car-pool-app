//
//  LoginVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 10/20/22.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
                print("login user!",user!)
                self.goToLogin()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Login"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func performLogin(_ sender: Any) {
        if let username = userNameTF.text{
            if let psd = passwordTF.text{
                Auth.auth().signIn(withEmail: username, password: psd) { authResult, error in
                    print("Auth results ",error!)
                }
            }
        }
    }
    
    @IBAction func goToNewUser(_ sender: Any) {
        performSegue(withIdentifier: "createUser", sender: self)
    }
    
    func goToLogin(){
        performSegue(withIdentifier: "loginSuccess", sender: self)
    }
}

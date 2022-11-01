//
//  NewUserVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/1/22.
//

import UIKit
import FirebaseAuth

class NewUserVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            let handle = Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    print(user!.email!)
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    
    @IBAction func createNewUser(_ sender: Any) {
        if let username = usernameTF.text{
            if let psd = passwordTF.text{
                Auth.auth().createUser(withEmail: username, password: psd) { authResult, error in
                    print("Auth results ",error)
                    if error == nil{
                        Auth.auth().signIn(withEmail: username, password: psd)
                    }
                }
            }
        }
    }
    
}

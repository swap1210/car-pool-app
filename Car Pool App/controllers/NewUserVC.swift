//
//  NewUserVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/1/22.
//

import UIKit
import FirebaseAuth

class NewUserVC: UIViewController {

    var userListener:AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var usrTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            userListener = Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    print(user!.email!)
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    
    @IBAction func createNewUser(_ sender: Any) {
        if let username = usrTF.text{
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if let handle = self.userListener{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

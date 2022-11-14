//
//  UserTypeSelector.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 10/20/22.
//

import UIKit
import FirebaseAuth

class UserTypeSelector: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select User type"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.logoutLogin()
    }
    
    func logoutLogin(){
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
                print(user!)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.rightHandAction))
            }else{
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    func rightHandAction(){
        try? Auth.auth().signOut()
    }
    
    @IBAction func buttonSelectDriver(_ sender: Any) {
        performSegue(withIdentifier: "selectedDriver", sender: self)
    }
    
    @IBAction func buttonSelectPassenger(_ sender: Any) {
        performSegue(withIdentifier: "selectedPassenger", sender: self)
    }
    
    @IBAction func goToSample(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSample", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

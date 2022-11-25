//
//  UserTypeSelector.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 10/20/22.
//

import UIKit
import FirebaseAuth

class UserTypeSelector: UIViewController {
    var driverMode: Bool!
    @IBOutlet weak var greetingLabel: UILabel!
    var userHandle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select User type"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.logoutLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let h = self.userHandle else{
            return
        }
        Auth.auth().removeStateDidChangeListener(h)
    }
    
    func logoutLogin(){
        self.userHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
//                print(user!)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.rightHandAction))
                self.greetingLabel.text = "Welcome "+(user?.email ?? "")+""
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
        self.driverMode = false
        performSegue(withIdentifier: "selectedPassenger", sender: self)
    }
    
    @IBAction func goToSample(_ sender: UIButton) {
        self.driverMode = true
        performSegue(withIdentifier: "selectedPassenger", sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let pass = segue.destination as? PassengerDashboardTableVC{
             pass.driverMode = self.driverMode
         }
     }
}

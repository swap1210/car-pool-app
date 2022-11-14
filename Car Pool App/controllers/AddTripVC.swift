//
//  AddTripVC.swift
//  Car Pool App
//
//  Created by Areeb on 11/1/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddTripVC: UIViewController {
    var db: Firestore!
    var currentCount = 0
    var currentUser: User? = nil

    
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toAT: UIDatePicker!
    @IBOutlet weak var fromAt: UIDatePicker!
    @IBOutlet weak var toTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        
        db = Firestore.firestore()
        addDocListener()
        getCurrentLoginDetails()
    }
    
    func addDocListener(){
        self.db.collection(Common.CPcollection).document(Common.document)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                if let _rides = data[Common.mainField] as? NSDictionary{
                    self.currentCount = _rides["count"] as! Int
//                    print("Current data: \(_rides.count)")
                }
            }
        
    }
    
    func getCurrentLoginDetails(){
        self.currentUser = Auth.auth().currentUser
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let from = self.fromTF.text
        let to = self.toTF.text
        let fromAtVal = self.fromAt.date
        let toAtVal = self.toAT.date
        
        var res = false
        var passengersArr:[String] = []
        
        if let curPass = self.currentUser?.email{
            passengersArr.append(curPass)
        }
        
        if (from != nil && to != nil && fromAtVal < toAtVal){
            res = self.addRide(ride: Ride(from: from!, to: to!, timeFrom: Timestamp(date:fromAtVal), timeTo: Timestamp(date:toAtVal),passengers: passengersArr))
        }
        
        if (res){
            //back to previous screen
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            print("Error while inserting ride");
        }
    }
    
    func addRide(ride: Ride)-> Bool{
        let ridesRef = db.collection(Common.CPcollection).document(Common.document)
        var finalResult = false
        ridesRef.updateData([Common.mainField+".records."+String(self.currentCount+1):ride.toNSDictionary()]){err in
            if let err = err{
                print("Write Error \(err)")
                finalResult =  false
            }else{
                //Increment count
                ridesRef.updateData([Common.mainField+".count" : FieldValue.increment(Int64(1))])
                finalResult = true
            }
        }
        return finalResult
    }
}

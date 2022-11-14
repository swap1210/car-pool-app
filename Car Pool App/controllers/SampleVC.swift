//
//  SampleVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/1/22.
//

import UIKit
import FirebaseFirestore

class SampleVC: UIViewController {
    var db: Firestore!
    var currentCount = 0
    let subGroup = "driverData"
    
    @IBOutlet weak var testField: UILabel!
    @IBOutlet weak var liveData: UILabel!
    @IBOutlet weak var addRecord: UIButton!
    @IBOutlet weak var sampleInputTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        
        db = Firestore.firestore()
        //adding records lstener
        db.collection("overall-data").document("rides")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                if let _rides = data[self.subGroup] as? NSDictionary{
                    self.currentCount = _rides["count"] as! Int
                    if let _ridesRecords = _rides["records"] as? NSDictionary{
                        for ride in _ridesRecords{
                            let rideS = Ride(dictionary:ride.value as! NSDictionary)
                            self.liveData.text = rideS.from
                        }
                    }
                    print("Current data: \(_rides.count)")
                }
            }
        
        db.collection("overall-data").document("rides").addSnapshotListener { documentSnapshot, err in
            //print("Got",documentSnapshot?.get("TestField"))
            self.testField.text = documentSnapshot?.get("TestField.we") as? String
            print("Err ",err!)
        }
    
    }
    
    @IBAction func createRide(_ sender: UIButton) {
        let tempRide = Ride(from:"From Loc",to:"To Loc",timeFrom:Timestamp(date: Date()),timeTo:Timestamp(date: Date()))
        if (addRide(ride: tempRide)){
            print("Write Success")
        }else{
            print("Write Error")
        }
    }
    
    func addRide(ride: Ride)-> Bool{
        let ridesRef = db.collection("overall-data").document("rides")
        var finalResult = false
        ridesRef.updateData([subGroup+".records."+String(self.currentCount+1):ride.toNSDictionary()]){err in
            if let err = err{
                print("Write Error \(err)")
                finalResult =  false
            }else{
                //Increment count
                ridesRef.updateData([self.subGroup+".count" : FieldValue.increment(Int64(1))])
                finalResult = true
            }
        }
        return finalResult
    }
    
    
    @IBAction func removeRecord(_ sender: UIButton) {
        if (sampleInputTF.text! != "" && removeRide(index: sampleInputTF.text!)){
            print("Remove Success")
        }else{
            print("Remove Error")
        }
    }
    
    func removeRide(index: String)-> Bool{
        //donot pass invalid value
        var finalResult = false
//        let oldCount = currentCount
        let ridesRef = db.collection("overall-data").document("rides")
        ridesRef.updateData([
            subGroup+".records."+index: FieldValue.delete(),
        ]) { [self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                //Decrement count
                ridesRef.updateData([self.subGroup+".count" : FieldValue.increment(Int64(-1))])
                print("Document successfully updated ")
                finalResult = true
            }
        }
        return finalResult
    }
}

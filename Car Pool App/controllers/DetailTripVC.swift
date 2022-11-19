//
//  DetailTripVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/14/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DetailTripVC: UIViewController {
    var isDriver:Bool!
    var TripId:Int!
    
    private var rideListner: ListenerRegistration? = nil
    private var currentRide: Ride?
    private var db: Firestore!
    
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var passengerHeader: UILabel!
    @IBOutlet weak var passengerStack: UIStackView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var driverLabel: UILabel!
    var currentUser: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // [END setup]
        self.currentUser = Auth.auth().currentUser?.email ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startRideListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.rideListner?.remove()
    }
    
    func startRideListener(){
        self.rideListner =
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
                
                guard let _rides = (((data[Common.mainField] as! NSDictionary)["records"]  as! NSDictionary)[String(self.TripId)] as? NSDictionary) else{
                    print("No ride")
                    return
                }
                
                self.loadLabels(ride: Ride(dictionary: _rides))
            }
    }
    
    func loadLabels(ride:Ride){
        print(ride)
        self.fromAddressLabel.text = ride.from
        self.toAddressLabel.text = ride.to
        self.fromDateLabel.text = ride.timeFrom.dateValue().formatted()
        self.toDateLabel.text = ride.timeTo.dateValue().formatted()
        
        self.driverLabel.text = ride.driver == nil || ride.driver == "" ? "Not assigned":ride.driver
        if (self.isDriver){
            if (ride.driver == self.currentUser){
                self.changeButton.titleLabel?.text = "I won't drive"
            }else{
                self.changeButton.titleLabel?.text = "I'll drive"
            }
        }else{
            if (ride.passengers.contains(self.currentUser)){
                self.changeButton.titleLabel?.text = "Remove me from trip"
            }else{
                self.changeButton.titleLabel?.text = "Add me to trip"
            }
        }
        var ctr = 1
        self.passengerHeader.text = "Passengers (\(ride.passengers.count)/\(Common.allowedPassengers)):"
        self.passengerStack.subviews.forEach({ $0.removeFromSuperview() })
        ride.passengers.forEach { passengerName in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
            label.text = " "+String(ctr)+". "+passengerName
            ctr+=1
            self.passengerStack.addArrangedSubview(label)
        }
    }
    
    @IBAction func addOrRemove(_ sender: UIButton) {
        if (self.isDriver){
            
        }else{
            if (sender.titleLabel?.text == "Add me to trip"){
                self.changeButton.titleLabel?.text = "Default text"
            }else{
                self.changeButton.titleLabel?.text = "Default text"
            }
        }
    }
}

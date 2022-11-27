//
//  PassengerDashboardTableVC.swift
//  Car Pool App
//
//  Created by Ly, Bao Thai on 10/21/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PassengerDashboardTableVC: UITableViewController {

    var db: Firestore!
    var rideArray: [Ride] = []
    var currentCount = 0
    var currentTripId: Int = 0
    private var rideListner: ListenerRegistration? = nil
    var myEmail: String?
    let dateFormatter = DateFormatter()

    @IBOutlet weak var addPassengerBtn: UIBarButtonItem!
    
    @IBOutlet var passengerView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        self.title = "Passenger Dashboard"
        
        self.myEmail = Auth.auth().currentUser?.email ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateTrips()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.rideListner?.remove()
    }
    
    func populateTrips() {
        
        self.rideListner = db.collection(Common.CPcollection).document(Common.document)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                self.rideArray = []
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                if let _rides = data[Common.mainField] as? NSDictionary{
                    self.currentCount = _rides["count"] as! Int
                    if let _ridesRecords = _rides["records"] as? NSDictionary{
                        for ride in _ridesRecords{
                            var rideS = Ride(dictionary:ride.value as! NSDictionary)
                            rideS.tripID = Int(ride.key as! String)
                            if rideS.timeFrom.dateValue() > Date(){
                                    if rideS.passengers.count <= Common.allowedPassengers{
                                        if rideS.driver != self.myEmail{//not include records where current user is driver
                                            self.rideArray.append(rideS)
                                        }
                                    }
                            }
                        }
                    }
                    self.passengerView.reloadData()
                }
            }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as! PassengerDashboardTableViewCell

        cell.destination.text = rideArray[indexPath.row].from + " - " + rideArray[indexPath.row].to
        cell.driver.text = "Driver: " + rideArray[indexPath.row].driver
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        cell.passengers.text = dateFormatter.string(from: rideArray[indexPath.row].timeFrom.dateValue()) + " - " + dateFormatter.string(from: rideArray[indexPath.row].timeTo.dateValue())
        if let myEmail = myEmail{
                cell.itHasMe = rideArray[indexPath.row].passengers.contains(myEmail)
        }
        cell.checkItHasMe()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func addTrip(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTrip", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTripId = rideArray[indexPath.row].tripID!
        performSegue(withIdentifier: "passengerToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passengerToDetails"{
            if let detailVC = segue.destination as? DetailTripVC{
                detailVC.isDriver = false
                detailVC.TripId = currentTripId
            }
        }
    }
}

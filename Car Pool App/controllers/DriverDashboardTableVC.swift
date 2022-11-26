//
//  DriverDashboardTableVC.swift
//  Car Pool App
//
//  Created by Ly, Bao Thai on 10/21/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

/*
struct Trip{
    var destination = ""
    var requester = ""
}
 */

class DriverDashboardTableVC: UITableViewController {

    @IBOutlet var driverView: UITableView!
    
    var db: Firestore!
    var rideArray: [Ride] = []
    var currentCount = 0
    var currentTripId: Int = 0
    private var rideListner: ListenerRegistration? = nil
    var myEmail: String?
    let dateFormatter = DateFormatter()
    var isDriverArr: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Driver Dashboard"
        
        db = Firestore.firestore()
        self.myEmail = Auth.auth().currentUser?.email ?? ""
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                                if rideS.driver == "" || rideS.driver == self.myEmail{
                                    
                                    if (rideS.passengers.contains(self.myEmail!))
                                    {
                                        self.isDriverArr.append(false)
                                    }
                                    else
                                    {
                                        self.rideArray.append(rideS)
                                        self.isDriverArr.append(true)
                                    }
                                        
                                    //print(rideS.passengers)
                                    //self.rideArray.append(rideS)
                                }
                            }
                        }
                    }
                    
                }
                self.driverView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as! DriverDashboardTableViewCell

        cell.destination.text = rideArray[indexPath.row].from + " - " + rideArray[indexPath.row].to
        cell.driver.text = "Driver: " + rideArray[indexPath.row].driver
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        cell.time.text = dateFormatter.string(from: rideArray[indexPath.row].timeFrom.dateValue()) + " - " + dateFormatter.string(from: rideArray[indexPath.row].timeTo.dateValue())
        
        //highlight driver cell
        /*
        if(isDriverArr[indexPath.row])
        {
            cell.contentView.backgroundColor = UIColor.green
        }
         */
        
        if (rideArray[indexPath.row].driver == self.myEmail)
        {
            cell.contentView.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    // size of cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTripId = rideArray[indexPath.row].tripID!
        performSegue(withIdentifier: "driverToDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverToDetails"{
            if let detailVC = segue.destination as? DetailTripVC{
                detailVC.isDriver = true
                detailVC.TripId = currentTripId
            }
        }
    }

}

//
//  PassengerDashboardTableVC.swift
//  Car Pool App
//
//  Created by Ly, Bao Thai on 10/21/22.
//

import UIKit
import FirebaseFirestore

class PassengerDashboardTableVC: UITableViewController {

    var db: Firestore!
    var rideArray: [Ride] = []
    var currentCount = 0

    @IBOutlet var passengerView: UITableView!
    var destinationArray: [String] = []//["Kroger", "UHCL", "Hawk's Landing", "Walmart"]
    //var requesterArray: [String] = []//["John", "Ben", "Maria", "Paul"]
//    @IBOutlet weak var destination: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        self.title = "Passenger Dashboard"
        
        populateTrips()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateTrips()
    }
    
    func populateTrips() {
        
        
        db.collection(Common.CPcollection).document(Common.document)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                self.destinationArray = []
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                if let _rides = data[Common.mainField] as? NSDictionary{
                    self.currentCount = _rides["count"] as! Int
                    if let _ridesRecords = _rides["records"] as? NSDictionary{
                        
                        for ride in _ridesRecords{
                            let rideS = Ride(dictionary:ride.value as! NSDictionary)
                            
                            if rideS.timeFrom.dateValue() > Date(){
                                if rideS.passengers.count < 4{
                                    self.rideArray.append(rideS)
                                    self.destinationArray.append(rideS.to)
                                    //self.destination.text = rideS.from
                                }
                            }
                        }
                    }
                    self.passengerView.reloadData()
                    print("Current data: \(_rides.count)")
                }
            }
        
//        let end = self.destinationArray.count - 1
//        for i in 0...end {
//            var trip = Trip()
//            trip.destination = destinationArray[i]
//            trip.requester = destinationArray[i]
//            tripArray.append(trip)
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return destinationArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as! PassengerDashboardTableViewCell

        cell.destination.text = destinationArray[indexPath.row]
//        cell.destination.text = tripArray[indexPath.row].destination
//        cell.requester.text = tripArray[indexPath.row].requester

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func addTrip(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTrip", sender: self)
    }
}

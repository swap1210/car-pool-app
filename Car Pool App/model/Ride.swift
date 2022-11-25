//
//  Ride.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/2/22.
//

import Foundation
import FirebaseFirestore

struct Ride{
    var from: String
    var to: String
    var timeFrom: Timestamp
    var timeTo: Timestamp
    var driver: String
    var passengers: [String]
    var tripID: Int?
    
    init(dictionary: NSDictionary){
        self.from = (dictionary["from"] as? String ?? "")
        self.to = (dictionary["to"] as? String ?? "")
        self.timeTo = (dictionary["timeTo"] as! Timestamp)
        self.timeFrom = (dictionary["timeFrom"] as! Timestamp)
        self.passengers = (dictionary["passengers"] as? [String] ?? [])
<<<<<<< HEAD
<<<<<<< HEAD
        self.driver = (dictionary["driver"] as? String ?? "")
=======
        
>>>>>>> 0a48952 (Update Driver Table View)
=======
        
>>>>>>> ec89cc94e67cfed68c7ac953d3a62e21574ad9ee
    }
    
    init(from: String,to: String,timeFrom: Timestamp,timeTo: Timestamp,driver: String,passengers: [String] = []){
        self.from = from
        self.to = to
        self.timeFrom = timeFrom
        self.timeTo = timeTo
        self.passengers = passengers
        self.driver = driver
    }
    
    func toNSDictionary()-> NSDictionary{
        return ["from":self.from,"to":self.to,"timeFrom":self.timeFrom,"timeTo":self.timeTo,"passengers":self.passengers,"driver":self.driver];
    }
}

//
//  CarpoolDBCRUD.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/1/22.
//

import Foundation
//import FirebaseCore
import FirebaseFirestore
//import FirebaseFirestoreSwift

class CarpoolDBCRUD: NSObject{
    var db: Firestore!
    
    func getLive(){
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
              print("Current data: \(data)")
            }
    }
}

//
//  SampleVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/1/22.
//

import UIKit
import FirebaseFirestore

class SampleVC: UIViewController {
    @IBOutlet weak var tripID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func openDriver(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTripDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailTripVC{
            dest.TripId = Int(self.tripID.text!)
            dest.isDriver = true
        }
    }
}

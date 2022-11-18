//
//  DetailTripVC.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/14/22.
//

import UIKit

class DetailTripVC: UIViewController {
    var isDriver:Bool!
    var TripId:Int!
    
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

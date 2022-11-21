//
//  PassengerDashboardTableViewCell.swift
//  Car Pool App
//
//  Created by Ly, Bao Thai on 10/24/22.
//

import UIKit

class PassengerDashboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var driver: UILabel!
    @IBOutlet weak var fromToLocation: UILabel!
    @IBOutlet weak var fromToTime: UILabel!
    var itHasMe: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func checkItHasMe(){
        if itHasMe == true{
            self.backgroundColor = UIColor.green
        }
        else{
            self.backgroundColor = nil
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ChatBubbleTableViewCell.swift
//  Car Pool App
//
//  Created by Swapnil Patel on 11/19/22.
//

import UIKit

class ChatBubbleTableViewCell: UITableViewCell {
    private var bubble: ChatBubble!
    
    @IBOutlet weak var bubbleImg: UIImageView!
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setBubble(bubble: ChatBubble){
        self.bubble = bubble
    }
}

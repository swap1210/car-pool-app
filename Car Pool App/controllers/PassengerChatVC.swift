//
//  PassengerChatVC.swift
//  Car Pool App
//
//  Created by Bui, Ryan on 10/25/22.
//

import UIKit
import MessageKit

/*
struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
 */

class PassengerChatVC: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{

    var currentSender: SenderType = Sender(senderId: "self", displayName: "Example DN")
    let currentUser = Sender(senderId: "self", displayName: "Example DN")
    let otherUser = Sender(senderId: "other", displayName: "Ryan")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello!")))
        
        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-76400), kind: .text("Hello, how are you?")))
        
        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-56400), kind: .text("Good!")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
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

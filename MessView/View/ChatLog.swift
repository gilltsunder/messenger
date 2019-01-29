//
//  ChatLog.swift
//  MessView
//
//  Created by Влад Третьяк on 12/25/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class ChatLog: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.clipsToBounds = true
            userImage.layer.cornerRadius = 35
        }
    }
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var message: Message? {
        didSet {
            guard let message = message else { return }
            setupNameAndProfileImage()
            self.messageText.text = message.text
            self.timestamp.text = DateFormatter.timeOnlyDateFormatter.string(from: message.timestamp)
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.opponentId {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    self.username.text = dict["name"] as? String
                    
                    if let img = dict["profileImageUrl"] {
                        let imgUrl = URL(string: img as! String)
                        self.userImage.kf.setImage(with: imgUrl!)
                    }
                }
            }, withCancel: nil)
        }
        
    }
}

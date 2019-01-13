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
    
    @IBOutlet weak var userImage: UIImageView!{
        didSet{
            
             userImage.clipsToBounds = true
            userImage.layer.cornerRadius = 35
           
        }
    }
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var message: Message? {
        didSet{
            
            setupNameAndProfileImage()
            
            self.messageText.text = self.message?.text
            
            if let seconds = self.message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                self.timestamp.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  UserListCell.swift
//  MessView
//
//  Created by Влад Третьяк on 12/25/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {

    
    @IBOutlet weak var userImg: UIImageView!{
        didSet{
            userImg.clipsToBounds = true
            userImg.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var caption: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

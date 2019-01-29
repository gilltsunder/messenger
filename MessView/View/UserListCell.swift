//
//  UserListCell.swift
//  MessView
//
//  Created by Влад Третьяк on 12/25/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    
    @IBOutlet var userImg: UIImageView! {
        didSet {
            userImg.clipsToBounds = true
            userImg.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet var name: UILabel!
    @IBOutlet var caption: UILabel!
}

extension UserListCell {
    static let reuseIdentifier = "UsersListCustomCell"
    static let preferredHeight: CGFloat = 85
}

extension UserListCell {
    
    func setup(with user: User) {
        userImg.kf.setImage(with: user.profileImageUrl)
        name.text = user.name
        caption.text = user.email
    }
}

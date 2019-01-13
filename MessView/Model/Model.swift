//
//  Model.swift
//  MessView
//
//  Created by Влад Третьяк on 12/25/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import Foundation

class UserList {
    var username: String?
    var useremail: String?
    var userimage: String?
    var userid: String?
    
    init(userName: String, userEmail: String, userImage: String, userId: String) {
        username = userName
        useremail = userEmail
        userimage = userImage
        userid = userId
    }
    
}

class currentMessagesModel : NSObject {
    var text : String?
    var fromId : String?
    var toId: String?
    var timestamp : NSNumber?
    
    init(fromIdd: String, textt: String, timestampp: NSNumber, toIdd: String) {
        fromId = fromIdd
        text = textt
        timestamp = timestampp
        toId = toIdd
    }
}




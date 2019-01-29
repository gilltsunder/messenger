//
//  Message.swift
//  MessView
//
//  Created by Влад Третьяк on 12/26/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase

struct Message: Codable {
    let fromId: String
    let toId: String
    let text: String?
    /// Prefer to use Date for that kind of types
    let timestamp: TimeInterval
}

extension Message {
    var opponentId: String {
        if Auth.auth().currentUser?.uid == fromId {
            return toId
        } else {
            return fromId
        }
    }
}

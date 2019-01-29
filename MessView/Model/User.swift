//
//  User.swift
//  MessView
//
//  Created by Влад Третьяк on 12/26/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase

struct User {
    let id: String
    let name: String
    let email: String
    let profileImageUrl: URL
}

extension User {
    init?(id: String, userParameters: [String: Any]) {
        guard let name = userParameters["name"] as? String else { return nil }
        guard let email = userParameters["email"] as? String else { return nil }
        guard let profileImageUrl = (userParameters["profileImageUrl"] as? String).flatMap ({ URL(string: $0) }) else { return nil }
        
        self.id = id
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
}

extension Decodable {
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}

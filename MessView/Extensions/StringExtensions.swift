//
//  StringExtensions.swift
//  MessView
//
//  Created by Влад Третьяк on 1/27/19.
//  Copyright © 2019 Влад Третьяк. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {

    var safe: String {
        switch self {
        case .none:
            return ""
        case .some(let string):
            return string
        }
    }
}

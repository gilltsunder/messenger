//
//  DateFormatters.swift
//  MessView
//
//  Created by Влад Третьяк  on 1/27/19.
//  Copyright © 2019 Влад Третьяк. All rights reserved.
//

import Foundation

extension DateFormatter {

    static let timeOnlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}

extension DateFormatter {

    func string(from timeIntervalSince1970: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return string(from: date)
    }
}

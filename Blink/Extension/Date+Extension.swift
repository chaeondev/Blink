//
//  Date+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/18/24.
//

import Foundation

enum DateFormatType: String {
    case allDate = "yyyy-MM-dd HH:mm:ss"
    case dotDate = "yy. MM. dd"
}

extension Date {
    
    // MARK: Date -> String
    func toString(dateType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = dateType.rawValue
        return dateFormatter.string(from: self)
    }
}

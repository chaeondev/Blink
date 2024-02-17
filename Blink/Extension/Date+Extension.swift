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
    case monthDay = "M/d"
    case timeWithAMPM = "hh:mm a"
    case apiDate = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case onlyDate = "yyyy년 M월 d일"
}

extension Date {
    
    // MARK: Date -> String
    func toString(dateType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = dateType.rawValue
        return dateFormatter.string(from: self)
    }
}

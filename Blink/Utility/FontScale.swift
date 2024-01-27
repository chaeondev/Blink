//
//  FontScale.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit

enum FontScale {
    case title1
    case title2
    case bodyBold
    case body
    case caption
    case caption2
    
    var fontSize: CGFloat {
        switch self {
        case .title1:
            return 22
        case .title2:
            return 14
        case .bodyBold:
            return 13
        case .body:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1:
            return 30
        case .title2:
            return 20
        case .bodyBold:
            return 18
        case .body:
            return 18
        case .caption:
            return 18
        case .caption2:
            return 18
        }
    }
    
    var weight: UIFont.Weight {
        switch self {
        case .title1:
            return .bold
        case .title2:
            return .bold
        case .bodyBold:
            return .bold
        case .body:
            return .regular
        case .caption:
            return .regular
        case .caption2:
            return .regular
        }
    }
}

//
//  UIFont+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit

extension UIFont {
    
    static func customFont(_ name: FontScale) -> UIFont {
        return UIFont.systemFont(ofSize: name.fontSize, weight: name.weight)
    }
}


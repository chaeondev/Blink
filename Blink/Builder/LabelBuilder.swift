//
//  LabelBuilder.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import Foundation

import UIKit

extension UILabel {
    static func labelBuilder(text: String, font: FontScale, textColor: UIColor, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .natural) -> UILabel {
        let view = UILabel()
        view.text = text
        view.font = UIFont.customFont(font)
        view.setLineSpacing(font: font)
        view.textColor = textColor
        view.numberOfLines = numberOfLines
        view.textAlignment = textAlignment
        return view
    }
}

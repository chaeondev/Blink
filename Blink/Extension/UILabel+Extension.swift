//
//  UILabel+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit

extension UILabel {
    func setLineSpacing(font: FontScale) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = font.lineHeight
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}

//
//  ButtonBuilder.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit

extension UIButton {
    static func buttonBuilder(image: UIImage? = nil, title: String? = nil, font: UIFont? = nil, titleColor: UIColor? = nil) -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = font
        view.setTitle(title, for: .normal)
        view.setImage(image, for: .normal)
        view.setTitleColor(titleColor, for: .normal)
        return view
    }
}

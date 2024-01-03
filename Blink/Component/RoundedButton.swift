//
//  RoundedButton.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit

final class RoundedButton: UIButton {
    
    init(image: UIImage? = nil, title: String, titleColor: UIColor = .brandWhite, backgroundColor: UIColor = .brandGreen) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        
        self.titleLabel?.font = UIFont.customFont(.title2)
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .brandGreen
            } else {
                self.backgroundColor = .brandInactive
            }
        }
    }
    
}

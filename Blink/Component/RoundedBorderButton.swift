//
//  RoundedBorderButton.swift
//  Blink
//
//  Created by Chaewon on 1/25/24.
//

import UIKit

final class RoundedBorderButton: UIButton {
    
    init(title: String, color: UIColor = .brandBlack) {
        super.init(frame: .zero)
        
        setButton()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        layer.borderColor = color.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton() {
        self.titleLabel?.font = .customFont(.title2)
        setTitleColor(.brandBlack, for: .normal)
        backgroundColor = .brandWhite
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.brandBlack.cgColor
    }
    
}

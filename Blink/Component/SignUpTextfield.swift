//
//  SignUpTextfield.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit

final class SignUpTextfield: UITextField {
    
    lazy var paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .backgroundSecondary
        self.layer.cornerRadius = 8
        self.placeholder = placeholder
        self.borderStyle = .none
        self.textColor = .brandBlack
        self.font = .customFont(.body)
        self.leftViewMode = .always
        self.leftView = paddingView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

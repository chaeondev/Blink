//
//  MoneyButton.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import UIKit

final class MoneyButton: UIButton {
    
    init(money: Int) {
        super.init(frame: .zero)
        
        self.setTitle("₩\(money)", for: .normal)
        self.titleLabel?.font = .customFont(.title2)
        self.setTitleColor(.brandWhite, for: .normal)
        
        self.backgroundColor = .brandGreen
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

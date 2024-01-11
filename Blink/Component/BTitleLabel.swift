//
//  SignUpLabel.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit

final class BTitleLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        self.font = .customFont(.title2)
        self.textColor = .brandBlack
        self.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

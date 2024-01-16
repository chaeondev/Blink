//
//  HomeCellTitleLabel.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomeCellTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        self.font = .customFont(.body)
        self.textColor = .textSecondary
    }
    
    func update(_ isBold: Bool) {
        if isBold {
            self.font = .customFont(.bodyBold)
            self.textColor = .textPrimary
        } else {
            self.font = .customFont(.body)
            self.textColor = .textSecondary
        }
    }
}

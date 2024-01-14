//
//  MessageCountLabel.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class MessageCountLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        backgroundColor = .brandGreen
        textColor = .brandWhite
        font = .customFont(.caption)
        textAlignment = .center
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setText(count: Int) {
        self.text = "\(count)"
    }
}

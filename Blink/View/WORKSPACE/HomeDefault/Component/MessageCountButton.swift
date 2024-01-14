//
//  MessageCountButton.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class MessageCountButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        backgroundColor = .brandGreen
        setTitleColor(.brandWhite, for: .normal)
        titleLabel?.font = .customFont(.caption)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setText(count: Int) {
        self.setTitle("\(count)", for: .normal)
    }
}

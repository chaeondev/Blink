//
//  CircleButton.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit

final class CircleButton: UIButton {
    init(image: UIImage) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        backgroundColor = .brandGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}

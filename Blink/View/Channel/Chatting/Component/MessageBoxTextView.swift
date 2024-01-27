//
//  MessageBoxTextView.swift
//  Blink
//
//  Created by Chaewon on 1/26/24.
//

import UIKit

final class MessageBoxTextView: UITextView {
    
    init(text: String) {
        super.init(frame: .zero, textContainer: nil)
        
        self.text = text
        setTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextView() {
        isScrollEnabled = false
        isEditable = false
        backgroundColor = .backgroundSecondary
        textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.brandInactive.cgColor
        font = .customFont(.body)
        self.sizeToFit()
    }
}

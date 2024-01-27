//
//  SenderTextView.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import UIKit

final class SenderTextView: UITextView {
    
    init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        
        self.text = placeholder
        setTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextView() {
        isScrollEnabled = false
        backgroundColor = .backgroundPrimary
        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        font = .customFont(.body)
        textColor = .textSecondary
        self.sizeToFit()
    }
}

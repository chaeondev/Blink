//
//  SendButton.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import UIKit

final class SendButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(.send, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(enable: Bool) {
        self.isEnabled = enable
        
        let image: UIImage = enable ? .sendActive : .send
        setImage(image, for: .normal)
    }
    
}

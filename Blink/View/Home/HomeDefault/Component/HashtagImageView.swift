//
//  HashtagImageView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HashtagImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        self.image = .hashtagThin
    }
    
    func update(_ isBold: Bool) {
        self.image = isBold ? .hashtagThick : .hashtagThin
    }
}

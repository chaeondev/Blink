//
//  ChevronImageView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class ChevronImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        self.image = .chevronRight
    }
    
    func updateImage(_ expanded: Bool) {
        self.image = expanded ? .chevronDown : .chevronRight
    }
}

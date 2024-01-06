//
//  BaseView.swift
//  Blink
//
//  Created by Chaewon on 1/6/24.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
    
    func setting() {
        
    }
}

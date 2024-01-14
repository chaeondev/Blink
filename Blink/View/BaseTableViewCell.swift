//
//  BaseTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    

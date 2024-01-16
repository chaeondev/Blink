//
//  HomePlusTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomePlusTableViewCell: BaseTableViewCell {
    
    let plusImageView = {
        let view = UIImageView()
        view.image = .plus
        return view
    }()
    
    let titleLabel = HomeCellTitleLabel()
    
    override func setHierarchy() {
        contentView.addSubview(plusImageView)
        contentView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(text: String) {
        titleLabel.text = text
    }
}

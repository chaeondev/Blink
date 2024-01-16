//
//  HomeSectionTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomeSectionTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel.labelBuilder(text: "채널", font: .title2, textColor: .brandBlack)
    let chevronImageView = ChevronImageView(frame: .zero)
    
    override func setHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(13)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(26.8)
            make.height.equalTo(24)
        }
    }
    
    func configureCell(text: String, expanded: Bool) {
        
        titleLabel.text = text
        chevronImageView.updateImage(expanded)
        
    }
    
}

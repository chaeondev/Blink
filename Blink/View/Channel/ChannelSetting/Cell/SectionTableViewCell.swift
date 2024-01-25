//
//  SectionTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

//높이 56
final class SectionTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel.labelBuilder(text: "멤버 (14)", font: .title2, textColor: .textPrimary)
    let chevronImageView = ChevronImageView(frame: .zero)
    
    override func setHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(26.8)
            make.height.equalTo(24)
        }
    }
    
    override func setting() {
        self.selectionStyle = .none
        self.backgroundColor = .backgroundPrimary
    }
    
    func configureCell(count: Int, expanded: Bool) {
        
        titleLabel.text = "멤버 (\(count))"
        chevronImageView.updateImage(expanded)
        
    }
}

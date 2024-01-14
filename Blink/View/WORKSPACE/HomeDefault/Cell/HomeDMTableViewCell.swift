//
//  HomeDMTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomeDMTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = .noPhotoB
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let titleLabel = HomeCellTitleLabel()
    let messageCountLabel = MessageCountLabel()
    
    override func setHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageCountLabel)
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(11)
            make.centerY.equalToSuperview()
        }
        
        messageCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16).priority(1000)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
    }
    
    func configureCell(image: String?, text: String, count: Int) {
        
        titleLabel.text = text
        messageCountLabel.setText(count: count)
        
        if count > 0 {
            titleLabel.update(true)
            messageCountLabel.isHidden = false
        } else {
            titleLabel.update(false)
            messageCountLabel.isHidden = true
        }
    }
}

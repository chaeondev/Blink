//
//  HomeChannelTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomeChannelTableViewCell: BaseTableViewCell {
    
    let hashtagImageView = HashtagImageView(frame: .zero)
    let titleLabel = HomeCellTitleLabel()
    let messageCountButton = MessageCountButton()
    
    override func setHierarchy() {
        contentView.addSubview(hashtagImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageCountButton)
    }
    
    override func setConstraints() {
        hashtagImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(hashtagImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        messageCountButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
    }
    
    func configureHomeCell(text: String, count: Int) {
        titleLabel.text = text
        messageCountButton.setText(count: count)
        
        if count > 0 {
            hashtagImageView.update(true)
            titleLabel.update(true)
            messageCountButton.isHidden = false
        } else {
            hashtagImageView.update(false)
            titleLabel.update(false)
            messageCountButton.isHidden = true
        }
    }
    
    func configureSearchCell(text: String) {
        titleLabel.text = text
        hashtagImageView.update(true)
        titleLabel.update(true)
        messageCountButton.isHidden = true
    }
}

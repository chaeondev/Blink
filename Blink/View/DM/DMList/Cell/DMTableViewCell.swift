//
//  DMTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import SnapKit

final class DMTableViewCell: BaseTableViewCell {
    
    //34x34
    let profileImageView = {
        let view = UIImageView()
        view.image = .dummy
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    //215x18
    let nameLabel = UILabel.labelBuilder(text: "옹골찬 고래밥", font: .caption, textColor: .brandBlack, numberOfLines: 1)
    
    //286x18 / 286x36 (최대 2줄)
    let contentLabel = UILabel.labelBuilder(text: "Cause I know what you like boy You're my chemical hype boy 내 지난날들은 눈 뜨면 잊는 꿈 Hype boyCause I know what you like boy You're my chemical hype boy", font: .caption2, textColor: .textSecondary, numberOfLines: 2)
    
    let dateLabel = UILabel.labelBuilder(text: "2023년 12월 22일", font: .caption2, textColor: .textSecondary, numberOfLines: 1, textAlignment: .right)
    
    let messageCntButton = {
        let view = MessageCountButton()
        view.setText(count: 10)
        return view
    }()
    
    override func setHierarchy() {
        [profileImageView, nameLabel, dateLabel, messageCntButton, contentLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        
        messageCntButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.trailing.equalTo(dateLabel)
            make.height.equalTo(18)
            make.width.lessThanOrEqualTo(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.width.equalToSuperview().multipliedBy(0.72)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    override func setting() {
        //self.selectionStyle = .none
        contentView.backgroundColor = .brandWhite
    }
    
    func configureCell(_ data: DMListCellInfo) {
        
        profileImageView.setKFImage(imageUrl: data.profileImage ?? "")
        nameLabel.text = data.nickname
        contentLabel.text = data.content
        
        //날짜 형식 변환
        let lastDate = data.date
        
        if isTodayOrNot(lastDate) {
            dateLabel.text = lastDate.toString(dateType: .timeWithAMPM)
        } else {
            dateLabel.text = lastDate.toString(dateType: .onlyDate)
        }
        
        //messageCount
        messageCntButton.setText(count: data.messageCnt)
        messageCntButton.isHidden = (data.messageCnt > 0) ? false : true
    }
    
    private func isTodayOrNot(_ date: Date) -> Bool {
        let current = Calendar.current
        return current.isDateInToday(date)
    }
}

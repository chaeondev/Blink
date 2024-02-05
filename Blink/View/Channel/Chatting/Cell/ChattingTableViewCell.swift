//
//  ChattingTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/26/24.
//

import UIKit

final class ChattingTableViewCell: BaseTableViewCell {
    
    //size 34
    let profileImageView = {
        let view = UIImageView()
        view.image = .noPhotoA
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let messageContentView = ChattingMessageContentView()
    
    let dateLabel = {
        let label = UILabel.labelBuilder(text: "1/13\n08:16 오전", font: .caption2, textColor: .textSecondary, numberOfLines: 2)
        label.contentMode = .bottomLeft
        return label
    }()
    
    override func setHierarchy() {
        [profileImageView, messageContentView, dateLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview()
            make.size.equalTo(34)
        }
        
        messageContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.width.lessThanOrEqualTo(244)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageContentView.snp.trailing).offset(8)
            make.bottom.equalTo(messageContentView)
        }
    }
    
    override func setting() {
        contentView.backgroundColor = .backgroundSecondary
    }
    
    func configureCell(_ chatInfo: ChattingInfoModel) {
        
        //1. profileImage update
        profileImageView.setKFImage(imageUrl: chatInfo.profileImage ?? "")
        
        //2. messageContentView update
        messageContentView.updateView(
            user: chatInfo.nickname,
            message: chatInfo.content ?? "",
            images: chatInfo.files
        )
        
        //3. dateLabel update
         // date 오늘인지 확인
         // 오늘이면 형식: 08:13 오전
         // 오늘 아니면 형식: 1/13\n08:16 오후
        let chatDate = chatInfo.createdAt
        
        if isTodayOrNot(chatDate) {
            self.dateLabel.text = chatDate.toString(dateType: .timeWithAMPM)
        } else {
            self.dateLabel.text = "\(chatDate.toString(dateType: .monthDay))\n\(chatDate.toString(dateType: .timeWithAMPM))"
        }
        
        
    }
    
    private func isTodayOrNot(_ date: Date) -> Bool {
        let current = Calendar.current
        return current.isDateInToday(date)
    }
    
}



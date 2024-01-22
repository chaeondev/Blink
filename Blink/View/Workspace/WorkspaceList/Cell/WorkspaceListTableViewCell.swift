//
//  WorkspaceListTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/16/24.
//

import UIKit
import RxSwift

final class WorkspaceListTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = .dummy
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let titleLabel = UILabel.labelBuilder(text: "영등포 새싹이들 모임", font: .bodyBold, textColor: .textPrimary)
    let dateLabel = UILabel.labelBuilder(text: "23.11.10", font: .body, textColor: .textSecondary)
    
    let optionButton = {
        let view = UIButton()
        view.setImage(.blackThreeDots, for: .normal)
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 1))
        contentView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        profileImageView.image = nil
    }
    
    override func setHierarchy() {
        [profileImageView, titleLabel, dateLabel, optionButton].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(18)
        }
        
        optionButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(20)
        }
    }
    
    func configureCell(data: WorkspaceInfoResponse, isSelected: Bool) {
        self.selectionStyle = .none
        
        if isSelected {
            contentView.backgroundColor = .brandGray
            optionButton.isHidden = false
        } else {
            contentView.backgroundColor = .brandWhite
            optionButton.isHidden = true
        }
        
        //이미지
        profileImageView.setKFImage(imageUrl: data.thumbnail)
        
        //타이틀
        titleLabel.text = data.name
        
        //날짜
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoDateFormatter.date(from: data.createdAt) {
            let formattedString = date.toString(dateType: .dotDate)
            dateLabel.text = formattedString
        }
        
    }
    
}

//
//  AdminTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit

final class AdminTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = .noPhotoB
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let nameLabel = UILabel.labelBuilder(text: "Courtney Henry", font: .bodyBold, textColor: .textPrimary)
    
    let emailLabel = UILabel.labelBuilder(text: "henry.courtney@example.com", font: .body, textColor: .textSecondary)
    
    override func prepareForReuse() {
        profileImageView.image = nil
    }
    
    override func setHierarchy() {
        [profileImageView, nameLabel, emailLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(14)
            make.size.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(11)
            make.height.equalTo(18)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
        }
    }
    
    func configureCell(_ data: User) {
        profileImageView.setKFImage(imageUrl: data.profileImage ?? "")
        nameLabel.text = data.nickname
        emailLabel.text = data.email
    }
}

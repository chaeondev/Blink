//
//  MemberCollectionViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit

//width: 76 height: 90
final class MemberCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.image = .noPhotoC
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let memberNameLabel = UILabel.labelBuilder(text: "Jack", font: .body, textColor: .brandBlack, textAlignment: .center)
    
    override func setHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(memberNameLabel)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(44)
        }
        
        memberNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(imageView)
            make.height.lessThanOrEqualTo(36)
        }
    }
    
    func configureCell(name: String, imageUrl: String?) {
        memberNameLabel.text = name
        imageView.setKFImage(imageUrl: imageUrl ?? "")
    }
}

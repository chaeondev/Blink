//
//  SendPhotoCollectionViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import UIKit
import SnapKit

final class SendPhotoCollectionViewCell: BaseCollectionViewCell {
    
    let photoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .blue
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let deleteButton = {
        let view = UIButton()
        view.setImage(.delete, for: .normal)
        return view
    }()
    
    override func setHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(deleteButton)
    }
    
    override func setConstraints() {
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView).offset(-6)
            make.trailing.equalTo(photoImageView).offset(6)
            make.size.equalTo(20)
        }
    }
    
    func configureCell(_ data: Data) {
        photoImageView.image = UIImage(data: data)
    }
}

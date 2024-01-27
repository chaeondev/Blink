//
//  ContentImageCollectionViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/26/24.
//

import UIKit
import SnapKit

final class ContentImageCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = .blue
        return view
    }()
    
    override func setHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(imageUrl: String) {
        imageView.setKFImage(imageUrl: imageUrl)
    }
}

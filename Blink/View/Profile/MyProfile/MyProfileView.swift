//
//  MyProfileView.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import UIKit
import SnapKit

final class MyProfileView: BaseView {
    let profileButton = {
        let view = UIButton()
        view.setImage(.noPhotoB, for: .normal)
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let cameraImageView = {
        let view = UIImageView()
        view.image = .camera
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .backgroundPrimary
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.description())
        view.rowHeight = 44
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    override func setHierarchy() {
        [profileButton, cameraImageView, tableView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.top.equalTo(profileButton).offset(51)
            make.leading.equalTo(profileButton).offset(53)
            make.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

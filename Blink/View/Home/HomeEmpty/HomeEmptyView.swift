//
//  HomeEmptyView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

class HomeEmptyView: BaseView {
    
    let titleLabel = UILabel.labelBuilder(text: "워크스페이스를 찾을 수 없어요.", font: .title1, textColor: .brandBlack, textAlignment: .center)
    let infoLabel = UILabel.labelBuilder(text: "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.", font: .body, textColor: .brandBlack, numberOfLines: 2, textAlignment: .center)
    let imageView = {
        let view = UIImageView()
        view.image = .workspaceEmpty
        view.contentMode = .scaleAspectFill
        return view
    }()
    let createButton = RoundedButton(title: "워크스페이스 생성")
    
    override func setHierarchy() {
        super.setHierarchy()
        [
            titleLabel,
            infoLabel,
            imageView,
            createButton
        ].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(35)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(30)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(345)
            make.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(368)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}

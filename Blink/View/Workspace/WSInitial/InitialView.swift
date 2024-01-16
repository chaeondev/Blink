//
//  InitialView.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit

class InitialView: BaseView {
    let titleLabel = UILabel.labelBuilder(text: "출시 준비 완료!", font: .title1, textColor: .brandBlack, textAlignment: .center)
    let infoLabel = UILabel.labelBuilder(text: "옹골찬 고래밥님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!", font: .body, textColor: .brandBlack, numberOfLines: 0, textAlignment: .center)
    let welcomImageView = {
        let view = UIImageView()
        view.image = .launching
        view.contentMode = .scaleAspectFill
        return view
    }()
    let createButton = RoundedButton(title: "워크스페이스 생성")
    
    override func setHierarchy() {
        super.setHierarchy()
        
        [
            titleLabel,
            infoLabel,
            welcomImageView,
            createButton
        ].forEach { self.addSubview($0) }
        
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
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        
        welcomImageView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.size.equalTo(368)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
}

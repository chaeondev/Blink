//
//  ChannelAddView.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class ChannelAddView: BaseView {
    
    let nameLabel = BTitleLabel(title: "채널 이름")
    let nameTextfield = BTextField(placeholder: "채널 이름을 입력하세요 (필수)")
    let descriptionLabel = BTitleLabel(title: "채널 설명")
    let descriptionTextfield = BTextField(placeholder: "채널을 설명하세요 (옵션)")
    let createButton = RoundedButton(title: "생성")
    
    override func setHierarchy() {
        [
            nameLabel,
            nameTextfield,
            descriptionLabel,
            descriptionTextfield,
            createButton
        ].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        nameTextfield.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextfield.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        descriptionTextfield.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}

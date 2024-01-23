//
//  InviteMemberView.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit

final class InviteMemberView: BaseView {
    
    let emailLabel = BTitleLabel(title: "이메일")
    let emailTextfield = BTextField(placeholder: "초대하려는 팀원의 이메일을 입력하세요.")
    let sendButton = RoundedButton(title: "초대 보내기")
    
    override func setHierarchy() {
        [emailLabel, emailTextfield, sendButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(24)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    override func setting() {
        super.setting()
        
        emailTextfield.textContentType = .emailAddress
        emailTextfield.keyboardType = .emailAddress
    }
}

//
//  LoginView.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit

class LoginView: BaseView {
    let emailLabel = BTitleLabel(title: "이메일")
    let emailTextField = BTextField(placeholder: "이메일을 입력하세요")
    let pwLabel = BTitleLabel(title: "비밀번호")
    let pwTextField = BTextField(placeholder: "비밀번호를 입력하세요")
    let loginButton = RoundedButton(title: "로그인")
    
    override func setHierarchy() {
        super.setHierarchy()
        
        [
            emailLabel,
            emailTextField,
            pwLabel,
            pwTextField,
            loginButton
        ].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    override func setting() {
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress

        pwTextField.textContentType = .newPassword
        pwTextField.isSecureTextEntry = true
    }
}

//
//  SignUpView.swift
//  Blink
//
//  Created by Chaewon on 1/6/24.
//

import UIKit

class SignUpView: BaseView {
    
    let emailLabel = BTitleLabel(title: "이메일")
    let emailTextField = BTextField(placeholder: "이메일을 입력하세요")
    let checkButton = RoundedButton(title: "중복확인")
    let nicknameLabel = BTitleLabel(title: "닉네임")
    let nicknameTextField = BTextField(placeholder: "닉네임을 입력하세요")
    let phoneLabel = BTitleLabel(title: "연락처")
    let phoneTextField = BTextField(placeholder: "전화번호를 입력하세요")
    let passwordLabel = BTitleLabel(title: "비밀번호")
    let passwordTextField = BTextField(placeholder: "비밀번호를 입력하세요")
    let repasswordLabel = BTitleLabel(title: "비밀번호 확인")
    let repasswordTextField = BTextField(placeholder: "비밀번호를 한 번 더 입력하세요")
    let joinButton = RoundedButton(title: "가입하기")
    
    override func setHierarchy() {
        [
            emailLabel,
            emailTextField,
            checkButton,
            nicknameLabel,
            nicknameTextField,
            phoneLabel,
            phoneTextField,
            passwordLabel,
            passwordTextField,
            repasswordLabel,
            repasswordTextField,
            joinButton
        ].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(233)
            make.height.equalTo(44)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(56)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        repasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        repasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(repasswordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        joinButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    override func setting() {
        //이메일
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        
        //전화번호
        phoneTextField.textContentType = .telephoneNumber
        phoneTextField.keyboardType = .phonePad
        
        //비밀번호
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        
        //비밀번호 확인
        repasswordTextField.textContentType = .newPassword
        repasswordTextField.isSecureTextEntry = true
    }
}

//
//  SignUpViewController.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private let emailLabel = SignUpLabel(title: "이메일")
    private let emailTextField = SignUpTextfield(placeholder: "이메일을 입력하세요")
    private let checkButton = RoundedButton(title: "중복확인")
    private let nicknameLabel = SignUpLabel(title: "닉네임")
    private let nicknameTextField = SignUpTextfield(placeholder: "닉네임을 입력하세요")
    private let phoneLabel = SignUpLabel(title: "연락처")
    private let phoneTextField = SignUpTextfield(placeholder: "전화번호를 입력하세요")
    private let passwordLabel = SignUpLabel(title: "비밀번호")
    private let passwordTextField = SignUpTextfield(placeholder: "비밀번호를 입력하세요")
    private let repasswordLabel = SignUpLabel(title: "비밀번호 확인")
    private let repasswordTextField = SignUpTextfield(placeholder: "비밀번호를 한 번 더 입력하세요")
    private let joinButton = RoundedButton(title: "가입하기")
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setUpSheet()
        bind()
    }
    
    private func bind() {
        navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigationbar() {
        title = "회원가입"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
    }
    
    private func setUpSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
    }
    
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
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(233)
            make.height.equalTo(44)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(56)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: SignUpViewController())
}

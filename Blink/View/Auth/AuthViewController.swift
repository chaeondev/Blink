//
//  AuthViewController.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit

final class AuthViewController: BaseViewController {
    
    private lazy var appleLoginButton = UIButton.buttonBuilder(image: .appleIDLogin)
    private lazy var kakaoLoginButton = UIButton.buttonBuilder(image: .kakaoLogin)
    private lazy var emailLoginButton = RoundedButton(image: .email, title: "이메일로 계속하기")
    private lazy var signUpButton = {
        let view = UIButton.buttonBuilder(title: "또는 새롭게 회원가입 하기", font: UIFont.customFont(.title2), titleColor: .brandGreen)
        let attrStr = NSMutableAttributedString(string: (view.titleLabel?.text)!)
        attrStr.addAttribute(.foregroundColor, value: UIColor.brandBlack, range: ((view.titleLabel?.text)! as NSString).range(of: "또는"))
        view.setAttributedTitle(attrStr, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        [
            appleLoginButton,
            kakaoLoginButton,
            emailLoginButton,
            signUpButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(20)
        }
    }
}

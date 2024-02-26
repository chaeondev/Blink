//
//  AuthViewController.swift
//  Blink
//
//  Created by Chaewon on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa

import AuthenticationServices

final class AuthViewController: BaseViewController {
    
    private let appleLoginButton = UIButton.buttonBuilder(image: .appleIDLogin)
    private let kakaoLoginButton = UIButton.buttonBuilder(image: .kakaoLogin)
    private let emailLoginButton = RoundedButton(image: .email, title: "이메일로 계속하기")
    private let signUpButton = {
        let view = UIButton.buttonBuilder(title: "또는 새롭게 회원가입 하기", font: UIFont.customFont(.title2), titleColor: .brandGreen)
        let attrStr = NSMutableAttributedString(string: (view.titleLabel?.text)!)
        attrStr.addAttribute(.foregroundColor, value: UIColor.brandBlack, range: ((view.titleLabel?.text)! as NSString).range(of: "또는"))
        view.setAttributedTitle(attrStr, for: .normal)
        return view
    }()
    
    let viewModel = AuthViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        let input = AuthViewModel.Input(
            kakaoLoginButtonTapped: kakaoLoginButton.rx.tap,
            appleLoginButtonTapped: appleLoginButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // MARK: 카카오 로그인
        output.kakaoLoginResult
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let response):
                    print("==Login Success== \(response)")
                case .loginFailed:
                    owner.toast(message: "카카오 로그인 오류가 발생했어요")
                case .networkError:
                    owner.toast(message: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        output.workspaceInfo
            .bind(with: self) { owner, type in
                switch type {
                case .empty:
                    owner.changeRootViewController(viewController: HomeEmptyViewController())
                case .notEmpty(let wsID):
                    let vc = HomeTabViewController()
                    vc.workspaceID = wsID
                    owner.changeRootViewController(viewController: vc)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 애플 로그인
        input.appleLoginButtonTapped
            .bind(with: self) { owner, _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email, .fullName]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            }
            .disposed(by: disposeBag)
        
        
        // MARK: 이메일 로그인
        emailLoginButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                let vc = SignUpViewController()
                let nav = UINavigationController(rootViewController: vc)
               
                self.present(nav, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
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

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("APPLE Login Failed \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        let vc = InitialViewController()
        self.present(vc, animated: true)
        
    }
}


extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

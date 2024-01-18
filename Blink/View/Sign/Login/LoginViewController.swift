//
//  LoginViewController.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title: "이메일 로그인")
        bind()
        
    }
    
    private func bind() {
        
        let input = LoginViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            loginButtonTap: mainView.loginButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // MARK: 버튼 활성화
        Observable.combineLatest(
            input.emailText.map { !$0.isEmpty },
            input.pwText.map { !$0.isEmpty }
        )
        .map { $0.0 && $0.1 }
        .bind(with: self) { owner, bool in
            owner.mainView.loginButton.rx.isEnabled.onNext(bool)
            owner.mainView.loginButton.backgroundColor = bool ? .brandGreen : .brandInactive
        }
        .disposed(by: disposeBag)
        
        // MARK: validation따른 title 변경, 커서 이동
        output.validationOutput
            .bind(with: self) { owner, list in
                print("===login validation output=== \(list)")
                
                //title 변경
                owner.mainView.emailLabel.textColor = list.contains(.invalidEmail) ? .brandError : .brandBlack
                owner.mainView.pwLabel.textColor = list.contains(.invalidPassword) ? .brandError : .brandBlack
                
                //커서 이동, 토스트메세지
                if let first = list.first {
                    var message: String {
                        switch first {
                        case .invalidEmail:
                            owner.mainView.emailTextField.becomeFirstResponder()
                            return "이메일 형식이 올바르지 않습니다."
                        case .invalidPassword:
                            owner.mainView.pwTextField.becomeFirstResponder()
                            return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
                        }
                    }
                    let toastPosition = owner.mainView.loginButton.frame.origin.y - 30
                    owner.toast(message: message, pointY: toastPosition)
                }
                
            }
            .disposed(by: disposeBag)
        
        //네트워크 결과
        output.loginResult
            .bind(with: self) { owner, result in
                
                let toastPosition = owner.mainView.loginButton.frame.origin.y - 30
                
                switch result {
                case .success(let response): 
                    print("==Login Success== \(response)")
                case .loginFailed:
                    owner.toast(message: "이메일 또는 비밀번호가 올바르지 않습니다.", pointY: toastPosition)
                case .networkError:
                    owner.toast(message: "에러가 발생했어요. 잠시 후 다시 시도해주세요.", pointY: toastPosition)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 로그인 성공 후 화면전환
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

        // MARK: 네비게이션 dismiss 버튼
        navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}


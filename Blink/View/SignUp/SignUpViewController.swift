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
    
    
    private let mainView = SignUpView()
    private let viewModel = SignUpViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setUpSheet()
        bind()

    }
    
    private func bind() {
        
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            nickText: mainView.nicknameTextField.rx.text.orEmpty,
            phoneText: mainView.phoneTextField.rx.text.orEmpty,
            pwText: mainView.passwordTextField.rx.text.orEmpty,
            repwText: mainView.repasswordTextField.rx.text.orEmpty,
            checkEmailButtonTap: mainView.checkButton.rx.tap,
            joinButtonTap: mainView.joinButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        /* 이메일 */
        input.emailText
            .map { $0.count != 0 }
            .bind(with: self) { owner, bool in
                owner.mainView.checkButton.rx.isEnabled.onNext(bool)
                owner.mainView.checkButton.backgroundColor = bool ? .brandGreen : .brandInactive
            }
            .disposed(by: disposeBag)
        
        output.emailValidation
            .bind(with: self) { owner, validation in
                var toastMessage: String {
                    switch validation {
                    case .invalid:
                        return "이메일 형식이 올바르지 않습니다."
                    case .duplicated:
                        return "이미 가입한 이메일입니다."
                    case .networkError:
                        return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
                    case .available:
                        return "사용 가능한 이메일입니다."
                    }
                }
                let toastPosition = owner.mainView.joinButton.frame.origin.y - 30
                owner.toast(message: toastMessage, pointY: toastPosition)
            }
            .disposed(by: disposeBag)
        
        /* 전화번호 */
        output.phoneNum
            .bind(to: mainView.phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        /* 가입하기 버튼 */
        
        //버튼 활성화
        Observable.combineLatest(
            input.emailText.map { !$0.isEmpty },
            input.nickText.map { !$0.isEmpty },
            input.pwText.map { !$0.isEmpty },
            input.repwText.map { !$0.isEmpty }
        )
        .map { $0.0 && $0.1 && $0.2 && $0.3 }
        .bind(with: self) { owner, bool in
            owner.mainView.joinButton.rx.isEnabled.onNext(bool)
            owner.mainView.joinButton.backgroundColor = bool ? .brandGreen : .brandInactive
        }
        .disposed(by: disposeBag)
        
        //버튼 클릭 -> title 변경, 커서 이동, 토스트 메세지
        output.validationOutput
            .bind(with: self) { owner, list in
                print("===validationOutput=== \(list)")
                
                //title 변경
                owner.mainView.emailLabel.textColor = list.contains(.notVerifiedEmail) ? .brandError : .brandBlack
                owner.mainView.nicknameLabel.textColor = list.contains(.invalidNickname) ? .brandError : .brandBlack
                owner.mainView.phoneLabel.textColor = list.contains(.invalidPhoneNum) ? .brandError : .brandBlack
                owner.mainView.passwordLabel.textColor = list.contains(.invalidPassword) ? .brandError : .brandBlack
                owner.mainView.repasswordLabel.textColor = list.contains(.notSamePassword) ? .brandError : .brandBlack
  
                //커서 이동, 토스트 메세지
                if let first = list.first {
                    var message: String {
                        switch first {
                        case .notVerifiedEmail:
                            owner.mainView.emailTextField.becomeFirstResponder()
                            return "이메일 중복 확인을 진행해주세요"
                        case .invalidNickname:
                            owner.mainView.nicknameTextField.becomeFirstResponder()
                            return "닉네임은 1글자 이상 30글자 이내로 부탁드려요"
                        case .invalidPhoneNum:
                            owner.mainView.phoneTextField.becomeFirstResponder()
                            return "잘못된 전화번호 형식입니다."
                        case .invalidPassword:
                            owner.mainView.passwordTextField.becomeFirstResponder()
                            return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수문자를 설정해주세요."
                        case .notSamePassword:
                            owner.mainView.repasswordTextField.becomeFirstResponder()
                            return "작성하신 비밀번호가 일치하지 않습니다."
                        }
                    }
                    let toastPosition = owner.mainView.joinButton.frame.origin.y - 30
                    owner.toast(message: message, pointY: toastPosition)
                }
            }
            .disposed(by: disposeBag)
        
        //네트워크 결과
        output.networkResult
            .bind(with: self) { owner, result in
                
                let toastPosition = owner.mainView.joinButton.frame.origin.y - 30
                
                switch result {
                case .success(let response):
                    KeyChainManager.shared.create(account: .userID, value: "\(response.user_id)")
                    KeyChainManager.shared.create(account: .accessToken, value: response.token.accessToken)
                    KeyChainManager.shared.create(account: .refreshToken, value: response.token.refreshToken)
                    //UserDefaults -> Login True
                    
                    print("==Join Success== \(response)")
                case .alreadyJoined:
                    owner.toast(message: "이미 가입된 회원입니다. 로그인을 진행해주세요.", pointY: toastPosition)
                case .networkError:
                    owner.toast(message: "에러가 발생했어요. 잠시 후 다시 시도해주세요.", pointY: toastPosition)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        //네비게이션 X 버튼
        navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension SignUpViewController {
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
}

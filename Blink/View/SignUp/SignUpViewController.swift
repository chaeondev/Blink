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
        mainView.emailTextField.textContentType = .emailAddress
        mainView.emailTextField.keyboardType = .emailAddress
        
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
                        return "사용 가능한 이메일입니다."
                    case .networkError:
                        return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
                    case .available:
                        return "사용 가능한 이메일입니다."
                    }
                }
                owner.view.makeToast(toastMessage, duration: 2.0, point: CGPoint(x: 195, y: 650), title: nil, image: nil, completion: nil)
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

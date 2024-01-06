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
        
        //self.view.makeToast("사용 가능한 이메일입니다.", duration: 3.0, point: CGPoint(x: 195, y: 700), title: nil, image: nil, completion: nil)
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
        
        navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
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
    
}

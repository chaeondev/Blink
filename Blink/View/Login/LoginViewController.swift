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
        setNavigationbar()
        setUpSheet()
        
    }
    
    private func bind() {
        
        let input = LoginViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            loginButtonTap: mainView.loginButton.rx.tap
        )
        let output = viewModel.transform(input: input)
    }
}

extension LoginViewController {
    private func setNavigationbar() {
        title = "이메일 로그인"
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

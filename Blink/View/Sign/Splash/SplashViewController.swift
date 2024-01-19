//
//  SplashViewController.swift
//  Blink
//
//  Created by Chaewon on 1/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: BaseViewController {
    
    private let mainView = SplashView()
    private let viewModel = SplashViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let input = SplashViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.autoLoginValidation
            .bind(with: self) { owner, bool in
                if bool {
                    print("===자동 로그인 -> TabBar ===")
                    let vc = HomeTabViewController()
                    // TODO: 이부분 어떻게 할지 고민 workspaceID를 진짜 userdefaults로 저장해야하나
                    vc.workspaceID = 142
                    owner.changeRootViewController(viewController: vc)
                } else {
                    print("=== 자동 로그인 실패 -> Onboarding ===")
                    let onboardingVC = OnboardingViewController()
                    owner.changeRootViewController(viewController: onboardingVC)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

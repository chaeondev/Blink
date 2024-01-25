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
        
        
        Observable.combineLatest(output.autoLoginValidation, output.workspaceListResult)
            .bind(with: self) { owner, data in
                switch data.0 {
                case .accept:
                    print("===자동 로그인 -> TabBar ===")
                    
                    switch data.1 {
                    case .empty:
                        let vc = HomeEmptyViewController()
                        owner.changeRootViewController(viewController: vc)
                    case .notEmpty(let id):
                        let vc = HomeTabViewController()
                        vc.workspaceID = id
                        owner.changeRootViewController(viewController: vc)
                    case .nothing:
                        print("자동로그인 개빡친다..222")
                    }
                case .reject:
                    print("=== 자동 로그인 실패 -> Onboarding ===")
                    let onboardingVC = OnboardingViewController()
                    owner.changeRootViewController(viewController: onboardingVC)
                case .nothing:
                    print("자동로그인 개빡친다..")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

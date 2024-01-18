//
//  InitialViewController.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InitialViewController: BaseViewController {
    
    private let mainView = InitialView()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title: "시작하기")
        bind()
    }
    
    private func bind() {
        mainView.createButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WSAddViewController()
                let nav = UINavigationController(rootViewController: vc)
               
                owner.present(nav, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        // TODO: X 버튼 -> home empty/ default 분기처리
        
    }
}

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
        setNavigationbar()
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
        
    }
}

extension InitialViewController {
    private func setNavigationbar() {
        title = "시작하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
    } // TODO: 네비게이션 bar background color 변경 (white), border 처리
}

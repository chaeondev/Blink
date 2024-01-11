//
//  InitialViewController.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit

final class InitialViewController: BaseViewController {
    
    private let mainView = InitialView()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        
    }
}

extension InitialViewController {
    private func setNavigationbar() {
        title = "시작하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
    } // TODO: 네비게이션 bar background color 변경 (white), border 처리
}

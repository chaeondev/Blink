//
//  ChattingViewController.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingViewController: BaseViewController {
    
    private let mainView = ChattingView()
    let viewModel = ChattingViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        setNavigationBar()
        
        bind()
        
        viewModel.loadData {
            // MARK: 나중에 테이블 리로드 하기
        }
    }
    
    private func bind() {
        navigationItem.rightBarButtonItem!.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ChannelSettingViewController()
                vc.viewModel.channelInfo = owner.viewModel.channelInfo
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    

}

extension ChattingViewController {
    
    private func setNavigationBar() {
        title = "#\(viewModel.channelInfo.name)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .list, style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
        navigationItem.backButtonDisplayMode = .minimal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandWhite.withAlphaComponent(0.75)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
}

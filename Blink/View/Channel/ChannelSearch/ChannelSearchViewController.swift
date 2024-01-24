//
//  ChannelSearchViewController.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChannelSearchViewController: BaseViewController {
    
    private let mainView = ChannelSearchView()
    let viewModel = ChannelSearchViewModel()
    
    var loadData = PublishSubject<Void>()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title: "채널 탐색")
        
        bind()
        loadData.onNext(())
    }
    
    private func bind() {
        let input = ChannelSearchViewModel.Input(
            loadData: self.loadData,
            itemSelected: mainView.tableView.rx.itemSelected
            
        )
        let output = viewModel.transform(input: input)
        
        //Navigation X 버튼
        navigationItem.leftBarButtonItem!.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        //Table -> CellFowRowAt
        output.items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: HomeChannelTableViewCell.description(), cellType: HomeChannelTableViewCell.self)) { (row, element, cell) in
                
                cell.configureSearchCell(text: element.name)
            }
            .disposed(by: disposeBag)
        
        //isjoined -> 분기처리
        output.isjoined
            .subscribe(with: self) { owner, bool in
                
                guard let channelInfo = owner.viewModel.selectedItem else { return }
                
                if bool {
                    // 채널 채팅 화면으로 전환
                    print("====\(channelInfo.name)은 이미 가입한 채널임====")
                    
                    owner.transitionToChat(self.viewModel.workspaceID, channelInfo)
                    
                    
                } else {
                    // 채널 참여 Alert
                    owner.showTwoActionViewController(
                        title: "채널 참여",
                        message: "[\(channelInfo.name)] 채널에 참여하시겠습니까?",
                        doButtonTitle: "확인") {
                            
                            // 채널 채팅 화면으로 전환
                            owner.transitionToChat(self.viewModel.workspaceID, channelInfo)
                            
                        } cancelCompletion: {
                            owner.dismiss(animated: true)
                        }

                }
            }
            .disposed(by: disposeBag)

        
    }
}

extension ChannelSearchViewController {
    
    //채팅화면으로 전환하는 메서드
    func transitionToChat(_ workspaceID: Int, _ channelInfo: ChannelRes){
        let nav = UINavigationController()
        
        let homeVC = HomeDefaultViewController()
        homeVC.viewModel.workspaceID = workspaceID
        homeVC.navigationItem.backButtonDisplayMode = .minimal //이전화면에 설정해야지 효과 있음
        
        let chatVC = ChattingViewController()
        chatVC.viewModel.channelInfo = channelInfo
        chatVC.viewModel.workspaceID = workspaceID
        
        nav.setViewControllers([homeVC, chatVC], animated: false)
        self.changeRootViewController(viewController: nav)
    }
}

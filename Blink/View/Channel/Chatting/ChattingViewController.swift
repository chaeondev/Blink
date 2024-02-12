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
    
        setNavigationBar()
        setTableView()
        
        view.backgroundColor = .backgroundSecondary
        
        bind()
        
        loadData()
        
        mainView.senderView.updateView(images: ["",""])
    }
    
    private func setTableView() {
        mainView.messageTableView.delegate = self
        mainView.messageTableView.dataSource = self
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
    
    func loadData() {
        viewModel.loadData {
            self.mainView.messageTableView.reloadData()
            self.scrollToUnreadMessage()
        }
    }
    

}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.description(), for: indexPath) as? ChattingTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.dataForRowAt(indexPath)
        
        cell.configureCell(data)
        
        return cell
    }
    
    //loadData completion으로 들어갈것 -> 안읽은 메세지 처음것부터 보여주기
    func scrollToUnreadMessage() {
        if viewModel.scrollIndex != -1 {
            let row = viewModel.scrollIndex
            
            let indexPath = IndexPath(row: row, section: 0)
            
            self.mainView.messageTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
        //else 일떼 굳이 지정해야함? 어차피 없는데..
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

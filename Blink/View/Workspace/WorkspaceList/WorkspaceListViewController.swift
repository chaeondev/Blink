//
//  WorkspaceListViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa



final class WorkspaceListViewController: BaseViewController {
    
    var viewType: WorkspaceListViewType!
    
    lazy var mainView = WorkspaceListView(viewType)
    let viewModel = WorkspaceListViewModel()
    
    let disposeBag = DisposeBag()
    
    //tableView를 그려주는 시점을 만들거임
    var loadData = PublishSubject<Void>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setCustomLargeTitleNavigation(title: "워크스페이스")
        bind()
        
        //viewDidLoad마다 실행되는 시점 -> bind메서드 뒤에 있어야함! 왜..?
        loadData.onNext(())
        
    }
    
    func bind() {
        let input = WorkspaceListViewModel.Input(
            loadData: self.loadData
        )
        let output = viewModel.transform(input: input)
        
        //TableView 구성
        output.items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: WorkspaceListTableViewCell.description(), cellType: WorkspaceListTableViewCell.self)) { (row, element, cell) in
                
                let isSelected = self.viewModel.checkSelectedWS(element)
                
                cell.configureCell(data: element, isSelected: isSelected)
                
                //cell optionbutton 클릭 로직 구현
            }
            .disposed(by: disposeBag)
        
        //워크스페이스 생성, 추가 버튼 화면전환
        mainView.workspaceAddButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WSAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.workspaceCreateButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WSAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    func setView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
    }
 
    
}


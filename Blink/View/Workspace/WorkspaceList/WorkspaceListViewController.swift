//
//  WorkspaceListViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol WorkspaceListDelegate: AnyObject {
    func updateWorkspaceIDToHome(id: Int)
}

final class WorkspaceListViewController: BaseViewController {
    
    var viewType: WorkspaceListViewType!
    
    lazy var mainView = WorkspaceListView(viewType)
    let viewModel = WorkspaceListViewModel()
    
    let disposeBag = DisposeBag()
    
    //tableView를 그려주는 시점을 만들거임
    var loadData = PublishSubject<Void>()
    
    
    //delegate
    var delegate: WorkspaceListDelegate?
    
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
                cell.optionButton.rx.tap
                    .subscribe(with: self) { owner, value in
                        //userID가 workspace owner인지
                        
                        //1. 워크스페이스 오너일때
                        if "\(element.owner_id)" == KeyChainManager.shared.userID {
                            print("내가 워크스페이스 관리자")
                            owner.showFourActionSheet(
                                firstTitle: "워크스페이스 편집",
                                firstCompletion: {
                                    // TODO: 시간 되면 워크스페이스 편집 코드 작성하기!!
                                },
                                secondTitle: "워크스페이스 나가기",
                                secondCompletion: {
                                    owner.showTwoActionViewController(title: "워크스페이스 나가기", message: "정말 이 워크스페이스를 떠나시겠습니끼?") {
                                        owner.dismiss(animated: true)
                                        owner.showOneActionViewController(title: "워크스페이스 나가기", message: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.") {
                                            owner.dismiss(animated: true)
                                        }
                                    } cancelCompletion: {
                                        owner.dismiss(animated: true)
                                    }

                                },
                                thirdTitle: "워크스페이스 관리자 변경",
                                thirdCompletion: {
                                    
                                },
                                fourthTitle: "워크스페이스 삭제") {
                                    
                                }
                            
                        //2. 워크스페이스 오너가 아닐때
                        } else {
                            print("내가 워크스페이스 관리자 아님")
                            owner.showOneActionSheet(title: "워크스페이스 나가기") {
                                owner.showTwoActionViewController(title: "워크스페이스 나가기", message: "정말 이 워크스페이스를 떠나시겠습니끼?") {
                                    owner.viewModel.leaveWorkspace(element.workspace_id)
                                } cancelCompletion: {
                                    owner.dismiss(animated: true)
                                }
                            }
                            
                        }
                    }
                    .disposed(by: cell.disposeBag)
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
        
        //model Selected
        mainView.tableView.rx.modelSelected(WorkspaceInfoResponse.self)
            .subscribe(with: self) { owner, data in
                owner.delegate?.updateWorkspaceIDToHome(id: data.workspace_id)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        //워크스페이스 퇴장 네트워크 결과
        viewModel.leaveNetworkResult
            .bind(with: self) { owner, result in
                switch result {
                case .success(let isEmpty, let homeWSID):
                    if isEmpty {
                        owner.changeRootViewController(viewController: HomeEmptyViewController())
                    } else {
                        owner.delegate?.updateWorkspaceIDToHome(id: homeWSID!)
                        owner.dismiss(animated: true)
                    }
                case .noData:
                    print("===NODATA===")
                case .reject:
                    owner.toast(message: "채널 관리자이신 것 같아요. 채널 관리자는 채널에 대한 권한을 양도해야 워크스페이스를 퇴장할 수 있어요.")
                case .networkError:
                    print("===NETWORKERROR===")
                }
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    func setView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
    }
 
    
}


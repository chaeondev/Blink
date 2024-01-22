//
//  HomeDefaultViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

struct cellData {
    var title: String
    var opened: Bool
    var sectionData: [String]
}


final class HomeDefaultViewController: BaseViewController {
    
    private let mainView = HomeDefaultView()
    let viewModel = HomeDefaultViewModel()
    
    private var disposeBag = DisposeBag()
    
    //전달값
    var workspaceID: Int = 0
    
    //DEMO
    var tableViewData: [cellData] = []
    
    //Custom Navigation
    let customView = UIView()
    private lazy var leftButton = {
        let button = UIButton()
        button.setImage(.dummy, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    private lazy var naviTitleButton = {
        let button = UIButton()
        button.setTitle("iOS Developers Study", for: .normal)
        button.setTitleColor(.brandBlack, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.title1)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showWorkspaceListVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton = {
        let button = UIButton()
        button.setImage(.noPhotoA, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.border.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    private let navigationBlurView = {
        let view = UIView()
        view.backgroundColor = .alpha
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandWhite
        
        bind()
        
        setTableView()
        setCustomNavigationbar(customView: customView, left: leftButton, title: naviTitleButton, right: rightButton, blurView: navigationBlurView)
        
        
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
        //DEMO
        tableViewData = [
            cellData(title: "채널", opened: false, sectionData: ["일반", "스유 뽀개기", "앱스토어 홍보", "오픈라운지"]),
            cellData(title: "다이렉트 메시지", opened: false, sectionData: ["캠퍼스지킴이", "Hue", "Jack"]),
            cellData(title: "팀원 추가", opened: false, sectionData: ["cell"])
        ]


    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    //네트워크 통신만 해보자..! -> 시점 잡을 수 있도록 하기
    private func bind() {
        let input = HomeDefaultViewModel.Input(
            wsID: self.workspaceID
        )
        let output = viewModel.transform(input: input)
        
        // MARK: 네비게이션 leftButton, title 업데이트
        output.workspaceResource
            .bind(with: self) { owner, model in
                owner.naviTitleButton.setTitle(model.name, for: .normal)
                owner.leftButton.setKFImage(imageUrl: model.thumbnail, placeholderImage: .dummy)
            }
            .disposed(by: disposeBag)
        
        // MARK: 프로필 조회 -> 네비게이션 rightButton 업데이트
        output.profileResource
            .bind(with: self) { owner, model in
                owner.rightButton.setKFImage(imageUrl: model.profileImage ?? "", placeholderImage: .noPhotoB)
            }
            .disposed(by: disposeBag)
        
    }

}

// MARK: Side Menu
extension HomeDefaultViewController: SideMenuNavigationControllerDelegate {
    
    @objc private func showWorkspaceListVC() {
        let vc = WorkspaceListViewController()
        
        //HomeDefault에서는 NotEmpty -> workspaceID 넘겨주기
        vc.viewType = .notEmpty
        vc.delegate = self
        vc.viewModel.selectedWorkspaceID = self.workspaceID
        
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = UIScreen.main.bounds.width * 0.8
        menu.enableSwipeToDismissGesture = true
        SideMenuManager.default.leftMenuNavigationController = menu
        present(menu, animated: true)
    }
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        mainView.blurView.isHidden = false
        navigationBlurView.isHidden = false

    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        mainView.blurView.isHidden = true
        navigationBlurView.isHidden = true

    }
}

extension HomeDefaultViewController: WorkspaceListDelegate {
    
    // TODO: reload data
    func updateWorkspaceIDToHome(id: Int) {
        self.workspaceID = id
        //reload data
    }
    
}
extension HomeDefaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableViewData[section].opened) ? tableViewData[section].sectionData.count + 2 : 1
//        switch section {
//        case 0:
//        case 1:
//        case 2:
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = checkCellType(indexPath: indexPath)
        switch cellType {
        case .chevronCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSectionTableViewCell.description(), for: indexPath) as? HomeSectionTableViewCell else { return UITableViewCell() }
            let title = tableViewData[indexPath.section].title
            let opened = tableViewData[indexPath.section].opened
            cell.configureCell(text: title, expanded: opened)
            return cell
            
        case .channelCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.description(), for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
            let title = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            let count = 15
            cell.configureCell(text: title, count: count)
            return cell
            
        case .dmCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDMTableViewCell.description(), for: indexPath) as? HomeDMTableViewCell else { return UITableViewCell() }
            let title = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            let count = 8
            cell.configureCell(image: nil, text: title, count: count)
            return cell
            
        case .plusCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePlusTableViewCell.description(), for: indexPath) as? HomePlusTableViewCell else { return UITableViewCell() }
            var title: String {
                switch indexPath.section {
                case 0: return "채널 추가"
                case 1: return "새 메시지 시작"
                case 2: return "팀원 추가"
                default: return "오류 메세지"
                }
            }
            
            cell.configureCell(text: title)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = checkCellType(indexPath: indexPath)
        switch cellType {
        case .chevronCell:
            return 56
        case .channelCell, .dmCell:
            return 44
        case .plusCell:
            return 41
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //셀 선택 시 회색에서 다시 변하게 해줌
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            tableViewData[indexPath.section].opened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("section data 선택")
        }
    }
    
    func checkCellType(indexPath: IndexPath) -> HomeCellType {
        switch (indexPath.section, indexPath.row) {
        case (0,0), (1,0): 
            return .chevronCell
        case (0, tableViewData[0].sectionData.count + 1), (1, tableViewData[1].sectionData.count + 1):
            return .plusCell
        case (0, _):
            return .channelCell
        case (1, _):
            return .dmCell
        default:
            return .plusCell
        }
    }
}

enum HomeCellType {
    case chevronCell
    case channelCell
    case dmCell
    case plusCell
}

// TODO: - 메세지(count)버튼 커스텀(label, backView) / footer에 선 그리기 / 데이터 연결

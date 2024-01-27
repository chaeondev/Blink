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
    //var workspaceID: Int = 0
    //viewModel로 옮김
    
    
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
        
        // MARK: 임시로 로그아웃 버튼 만들어둠 -> 나중에 수정하기!!
        button.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
    
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
        
        
        fetchTableData()
        
        bind()

        setCustomNavigationbar(customView: customView, left: leftButton, title: naviTitleButton, right: rightButton, blurView: navigationBlurView)
        navigationItem.backButtonDisplayMode = .minimal
        
        setTableView()
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    //네트워크 통신만 해보자..! -> 시점 잡을 수 있도록 하기
    private func bind() {
        let input = HomeDefaultViewModel.Input()
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
    
    func fetchTableData() {
        viewModel.fetchChannelInfo {
            self.mainView.tableView.reloadData()
        }
        
        viewModel.fetchDMInfo {
            self.mainView.tableView.reloadData()
        }
    }
    
    // MARK: 임시로 만든 로그아웃
    @objc func logoutButtonClicked() {
        self.showTwoActionViewController(title: "로그아웃", message: "로그아웃 하시겠습니까?", doButtonTitle: "확인") {
            self.viewModel.logout {
                self.changeRootViewController(viewController: OnboardingViewController())
            }
        } cancelCompletion: {
            self.dismiss(animated: true)
        }

    }

}

// MARK: Side Menu
extension HomeDefaultViewController: SideMenuNavigationControllerDelegate {
    
    @objc private func showWorkspaceListVC() {
        let vc = WorkspaceListViewController()
        
        //HomeDefault에서는 NotEmpty -> workspaceID 넘겨주기
        vc.viewType = .notEmpty
        vc.delegate = self
        vc.viewModel.selectedWorkspaceID = self.viewModel.workspaceID
        
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

extension HomeDefaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.checkCellType(indexPath: indexPath)
        switch cellType {
        case .chevronCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSectionTableViewCell.description(), for: indexPath) as? HomeSectionTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.chevronData(indexPath: indexPath)
            cell.configureCell(text: data.title, expanded: data.opened)
            
            return cell
            
        case .channelCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.description(), for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.channelData(indexPath: indexPath)
            cell.configureHomeCell(text: data.title, count: data.count)
            
            return cell
            
        case .dmCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDMTableViewCell.description(), for: indexPath) as? HomeDMTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.dmData(indexPath: indexPath)
            cell.configureCell(image: data.image, text: data.title, count: data.count)
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
        let cellType = viewModel.checkCellType(indexPath: indexPath)
        switch cellType {
        case .chevronCell:
            return 56
        case .channelCell, .dmCell:
            return 44
        case .plusCell:
            return 41
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 2 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
            footer.backgroundColor = .seperator
            
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //셀 선택 시 회색에서 다시 변하게 해줌
        tableView.deselectRow(at: indexPath, animated: true)
        
        //cell 접었다 폈다 -> section reload 필요
        viewModel.toggleSection(indexPath: indexPath) {
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
        guard let channelData = viewModel.channelData,
              let dmData = viewModel.dmData else { return }
        
        switch (indexPath.section, indexPath.row) {
        case (2,0): //팀원추가(section2) cell 클릭한 경우 -> 화면전환
            let vc = InviteMemberViewController()
            vc.delegate = self
            vc.viewModel.workspaceId = self.viewModel.workspaceID
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        case (0, channelData.sectionData.count + 1): //채널추가 -> actionSheet
            self.showTwoActionSheet(
                firstTitle: "채널 생성",
                firstCompletion: {
                    let vc = ChannelAddViewController()
                    vc.viewModel.workspaceID = self.viewModel.workspaceID
                    vc.delegate = self
                    
                    let nav = UINavigationController(rootViewController: vc)
                    self.present(nav, animated: true)
                },
                secondTitle: "채널 탐색") {
                    let vc = ChannelSearchViewController()
                    vc.viewModel.workspaceID = self.viewModel.workspaceID
                    
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    
                    self.present(nav, animated: true)
                }
        case (0, _): //채널명
            // 채널 채팅 화면으로 전환
            guard let data = viewModel.channelData(indexPath: indexPath).channelInfo else { return }
            print("===채팅 전환 전 정보 확인===")
            print("===워크스페이스 ID: \(data.workspace_id)===")
            print("===채팅방 이름 & 아이디; \(data.name) & \(data.channel_id)===")
            
            let chatVC = ChattingViewController()
            chatVC.viewModel.channelInfo = data
            chatVC.viewModel.workspaceID = data.workspace_id
            
            self.navigationController?.pushViewController(chatVC, animated: true)
        default:
            return
        }
       
    }
    
    
}

// MARK: Delegate
extension HomeDefaultViewController: WorkspaceListDelegate {
    
    // TODO: reload data
    func updateWorkspaceIDToHome(id: Int) {
        self.viewModel.workspaceID = id
        //reload data
        
        //네비게이션바 업데이트
        bind()
        //Table 업데이트
        fetchTableData()
    }
    
}

extension HomeDefaultViewController: InvitationDelegate {
    func sendInvitationResultMessage(message: String) {
        self.toast(message: message)
    }
    
}

extension HomeDefaultViewController: CreateChannelDelegate {
    func sendToastMessageAndReload(_ message: String) {
        self.toast(message: message)
        viewModel.fetchChannelInfo {
            self.mainView.tableView.reloadSections([0], with: .none)
        }
        
    }
}

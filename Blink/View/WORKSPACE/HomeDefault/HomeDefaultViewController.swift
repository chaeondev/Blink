//
//  HomeDefaultViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

struct cellData {
    var title: String
    var opened: Bool
    var sectionData: [String]
}


final class HomeDefaultViewController: BaseViewController {
    
    private let mainView = HomeDefaultView()
    
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
        button.addTarget(self, action: #selector(presentSideMenu), for: .touchUpInside)
        button.isUserInteractionEnabled = true
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
    
    //SideMenu
    private let workspaceListVC = WorkspaceListViewController()
    private var dimmingView: UIView?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTableView()
        setNavigationBar()
        bind()
        
        //DEMO
        tableViewData = [
            cellData(title: "채널", opened: false, sectionData: ["일반", "스유 뽀개기", "앱스토어 홍보", "오픈라운지"]),
            cellData(title: "다이렉트 메시지", opened: false, sectionData: ["캠퍼스지킴이", "Hue", "Jack"]),
            cellData(title: "팀원 추가", opened: false, sectionData: ["cell"])
        ]
        
        //SideMenu
        addDimmingView()

    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func bind() {
        
    }
}

// MARK: SideMenu 직접 구현
extension HomeDefaultViewController {
    private func addDimmingView() {
        dimmingView = UIView()
        dimmingView?.backgroundColor = .alpha
        dimmingView?.isHidden = true
        //print("====dimmingView \(dimmingView)")
        view.addSubview(dimmingView!)
        
        dimmingView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        dimmingView?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleDimmingViewTap() {
        let sideMenuVC = self.workspaceListVC
        
        UIView.animate(withDuration: 0.3) {
            //사이드메뉴를 원래 위치로 되돌림
            sideMenuVC.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //어두운 배경 뷰를 숨김
            self.dimmingView?.alpha = 0
        } completion: { (finished) in
            //애니메이션이 완료된 후 사이드 메뉴를 뷰 계층구조에서 제거
            sideMenuVC.view.removeFromSuperview()
            sideMenuVC.removeFromParent()
            self.dimmingView?.isHidden = true
        }
    }
    
    @objc private func presentSideMenu() {
        let sideMenuVC = self.workspaceListVC
        
        //사이드 메뉴 뷰 컨을 자식으로 추가하고 뷰계층구조에 추가
        self.addChild(sideMenuVC)
        self.view.addSubview(sideMenuVC.view)
        
        let menuWidth = self.view.frame.width * 0.8
        let menuHeight = self.view.frame.height
        
        sideMenuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: menuHeight)
        
        self.dimmingView?.isHidden = false
        self.dimmingView?.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            sideMenuVC.view.frame = CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight)
            self.dimmingView?.alpha = 1
        }
    }
}

extension HomeDefaultViewController {
    func setNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let height = navigationBar.frame.size.height
        let width = navigationBar.frame.size.width
        
        [leftButton, naviTitleButton, rightButton].forEach { customView.addSubview($0) }
        
        
        customView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        naviTitleButton.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).offset(8)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8)
            make.centerY.equalTo(leftButton)
        }
        
        navigationItem.titleView = customView

        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandWhite
        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
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

// TODO: - 메세지 버튼 커스텀(label, backView) / footer에 선 그리기 / 데이터 연결

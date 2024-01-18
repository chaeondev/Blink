//
//  WorkspaceListView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

enum WorkspaceListViewType {
    case empty
    case notEmpty
}

final class WorkspaceListView: BaseView {
    
    var type: WorkspaceListViewType = .empty
    
    convenience init(_ type: WorkspaceListViewType) {
        self.init()
        
        self.type = type
        setView()
    }
    
    //Empty일때 Component
    let titleLabel = UILabel.labelBuilder(text: "워크스페이스를\n찾을 수 없어요.", font: .title1, textColor: .brandBlack, numberOfLines: 2, textAlignment: .center)
    let infoLabel = UILabel.labelBuilder(text: "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.", font: .body, textColor: .brandBlack, numberOfLines: 3, textAlignment: .center)
    let workspaceCreateButton = RoundedButton(title: "워크스페이스 생성")
    
    //notEmpty일때 Component
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(WorkspaceListTableViewCell.self, forCellReuseIdentifier: WorkspaceListTableViewCell.description())
        view.rowHeight = 72
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    
    //공통
    let titleBackView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        return view
    }()
    
    let workspaceAddButton = {
        let view = UIButton()
        view.setImage(.plus, for: .normal)
        view.setTitle("워크스페이스 추가", for: .normal)
        view.titleLabel?.font = .customFont(.body)
        view.setTitleColor(.textSecondary, for: .normal)
        view.contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 16
        view.configuration = config
        
        return view
    }()
    let helpButton = {
        let view = UIButton()
        view.setImage(.help, for: .normal)
        view.setTitle("도움말", for: .normal)
        view.titleLabel?.font = .customFont(.body)
        view.setTitleColor(.textSecondary, for: .normal)
        view.contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 16
        view.configuration = config
        
        return view
    }()
    
    override func setHierarchy() {
        //공통
        [titleBackView, workspaceAddButton, helpButton].forEach { self.addSubview($0) }
        
        //empty
        [titleLabel, infoLabel, workspaceCreateButton].forEach { self.addSubview($0) }
        
        //notEmpty
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        
        titleBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(98)
        }
        
        helpButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(41)
            make.bottom.equalToSuperview().offset(-33)
        }
        
        workspaceAddButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(41)
            make.bottom.equalTo(helpButton.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom).offset(183)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(55)
        }
        
        workspaceCreateButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom)
            make.leading.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(workspaceAddButton.snp.top)
        }
    }
    
    func setView() {
        switch type {
        case .empty:
            titleLabel.isHidden = false
            infoLabel.isHidden = false
            workspaceCreateButton.isHidden = false
            tableView.isHidden = true
        case .notEmpty:
            titleLabel.isHidden = true
            infoLabel.isHidden = true
            workspaceCreateButton.isHidden = true
            tableView.isHidden = false
        }
    }
    
    override func setting() {
        super.setting()
        self.backgroundColor = .white
    }
}

//
//  DMListView.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import SnapKit

final class DMListView: BaseView {
    
    let headerView = {
        let view = MemberListHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 114)
        return view
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = .brandWhite
        
        view.register(DMTableViewCell.self, forCellReuseIdentifier: DMTableViewCell.description())
        view.tableHeaderView = headerView
        
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        
        return view
    }()
    
    override func setHierarchy() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .brandWhite
    }
}

struct DMListCellInfo {
    let roomID: Int
    let roomCreatedAt: String
    
    //user
    let userID: Int
    let profileImage: String?
    let nickname: String
    
    //chatting
    var content: String
    var date: Date
    
    var messageCnt: Int
    
}

//
//  DMListView.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import SnapKit

final class DMListView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .brandWhite
        
        view.register(DMTableViewCell.self, forCellReuseIdentifier: DMTableViewCell.description())
        view.register(MemberListHeaderView.self, forHeaderFooterViewReuseIdentifier: MemberListHeaderView.description())
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = 0
        
        let footer = UIView()
        footer.frame.size.height = 1
        
        view.tableFooterView = footer
        view.sectionFooterHeight = 0
        
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
    
    //user
    let userID: Int
    let profileImage: String?
    let nickname: String
    
    //chatting
    let content: String
    let date: Date
    
    let messageCnt: Int
    
}

//
//  DMListView.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit

final class DMListView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(DMTableViewCell.self, forCellReuseIdentifier: DMTableViewCell.description())
        view.register(MemberListHeaderView.self, forHeaderFooterViewReuseIdentifier: MemberListHeaderView.description())
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = 0
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
        
        self.backgroundColor = .backgroundPrimary
    }
}

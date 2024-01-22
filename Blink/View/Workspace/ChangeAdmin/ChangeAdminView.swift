//
//  ChangeAdminView.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit

final class ChangeAdminView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(AdminTableViewCell.self, forCellReuseIdentifier: AdminTableViewCell.description())
        view.rowHeight = 60
        view.separatorStyle = .none
        view.backgroundColor = .backgroundPrimary
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func setHierarchy() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

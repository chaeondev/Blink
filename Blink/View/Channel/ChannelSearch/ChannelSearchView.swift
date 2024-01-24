//
//  ChannelSearchView.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class ChannelSearchView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(HomeChannelTableViewCell.self, forCellReuseIdentifier: HomeChannelTableViewCell.description())
        view.rowHeight = 41
        view.separatorStyle = .none
        view.backgroundColor = .backgroundSecondary
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func setHierarchy() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .backgroundSecondary
    }
}

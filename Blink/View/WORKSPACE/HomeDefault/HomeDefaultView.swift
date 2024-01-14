//
//  HomeDefaultView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

final class HomeDefaultView: BaseView {
    let tableView = {
        let view = UITableView(frame: .zero)
        
        view.register(HomeSectionTableViewCell.self, forCellReuseIdentifier: HomeSectionTableViewCell.description())
        view.register(HomeChannelTableViewCell.self, forCellReuseIdentifier: HomeChannelTableViewCell.description())
        view.register(HomeDMTableViewCell.self, forCellReuseIdentifier: HomeDMTableViewCell.description())
        view.register(HomePlusTableViewCell.self, forCellReuseIdentifier: HomePlusTableViewCell.description())
        
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
    
}

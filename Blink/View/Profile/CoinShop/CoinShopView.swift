//
//  CoinShopView.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import UIKit
import SnapKit
import WebKit

final class CoinShopView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .backgroundPrimary
        view.register(CoinShopTableViewCell.self, forCellReuseIdentifier: CoinShopTableViewCell.description())
        view.rowHeight = 44
        view.separatorStyle = .none
        view.isScrollEnabled = false
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

//
//  ChannelSettingView.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class ChannelSettingView: BaseView {
    
    //header -> InfoHeaderView -> dynamic height
    //Table Cell 2가지
    //SectionTableViewCell -> folding되어야 함
    //MemberListTableViewCell -> 높이 dynamic -> collectionview의 개수에 따라 변경되어야함
    //footer -> ButtonFooterView -> isowner에 따라 버튼 4개/1개
    
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.description())
        view.register(MemberListTableViewCell.self, forCellReuseIdentifier: MemberListTableViewCell.description())
        view.register(InfoHeaderView.self, forHeaderFooterViewReuseIdentifier: InfoHeaderView.description())
        view.register(ButtonFooterView.self, forHeaderFooterViewReuseIdentifier: ButtonFooterView.description())
        
        view.backgroundColor = .blue
        view.separatorStyle = .none
        
        return view
    }()
    
    override func setConstraints() {
        self.addSubview(tableView)
    }
    
    override func setHierarchy() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

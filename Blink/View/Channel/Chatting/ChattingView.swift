//
//  ChattingView.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class ChattingView: BaseView {
    
    let messageTableView = {
        let view = UITableView()
        view.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.description())
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .backgroundSecondary
        return view
    }()
    
    override func setHierarchy() {
        self.addSubview(messageTableView)
    }
    
    override func setConstraints() {
        messageTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top) // MARK: 이부분 sendView 만들면 바꾸기
        }
    }
    
    override func setting() {
        self.backgroundColor = .backgroundSecondary
    }
    
}


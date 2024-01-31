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
        view.separatorStyle = .none
        return view
    }()
    
    let senderView = SenderView()
    
    override func setHierarchy() {
        self.addSubview(messageTableView)
        self.addSubview(senderView)
    }
    
    override func setConstraints() {
        
        senderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(senderView.snp.top) // MARK: 이부분 sendView 만들면 바꾸기
        }
    }
    
    override func setting() {
        super.setting()
        self.backgroundColor = .backgroundSecondary
    }
    
}


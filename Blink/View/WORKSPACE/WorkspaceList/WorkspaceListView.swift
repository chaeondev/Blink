//
//  WorkspaceListView.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit

enum WorkspaceListViewType {
    case empty
    case notEmpty
}

final class WorkspaceListView: BaseView {
    
    var type: WorkspaceListViewType = .empty
    
    convenience init(type: WorkspaceListViewType) {
        self.init()
        
        self.type = type
    }
    
    //Empty일때 Component
    let titleLabel = UILabel.labelBuilder(text: "워크스페이스를\n찾을 수 없어요.", font: .title1, textColor: .brandBlack, numberOfLines: 2, textAlignment: .center)
    let infoLabel = UILabel.labelBuilder(text: "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.", font: .body, textColor: .brandBlack, numberOfLines: 3, textAlignment: .center)
    let workspaceCreateButton = RoundedButton(title: "워크스페이스 생성")
    
    //공통
    let titleBackView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        return view
    }()
    
    let workspaceAddButton = {
        let view = UIButton()
        view.setImage(.plus, for: .normal)
        view.setTitle("워크스페이스 추가", for: .normal)
        view.titleLabel?.font = .customFont(.body)
        view.setTitleColor(.textSecondary, for: .normal)
        view.contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 16
        view.configuration = config
        
        return view
    }()
    let helpButton = {
        let view = UIButton()
        view.setImage(.help, for: .normal)
        view.setTitle("도움말", for: .normal)
        view.titleLabel?.font = .customFont(.body)
        view.setTitleColor(.textSecondary, for: .normal)
        view.contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 16
        view.configuration = config
        
        return view
    }()
    
    override func setHierarchy() {
        //공통
        [titleBackView, workspaceAddButton, helpButton].forEach { self.addSubview($0) }
        
        //empty
        [titleLabel, infoLabel, workspaceCreateButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        titleBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(98)
        }
        
        helpButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(41)
            make.bottom.equalToSuperview().offset(-33)
        }
        
        workspaceAddButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(41)
            make.bottom.equalTo(helpButton.snp.top)
        }
    }
    
    override func setting() {
        super.setting()
        self.backgroundColor = .white
    }
}

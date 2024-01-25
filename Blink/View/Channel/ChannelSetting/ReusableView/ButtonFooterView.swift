//
//  ButtonFooterView.swift
//  Blink
//
//  Created by Chaewon on 1/25/24.
//

import UIKit
import SnapKit


//footer 높이 237
final class ButtonFooterView: UITableViewHeaderFooterView {
    
    //관리자일 때 버튼
    let editButton = RoundedBorderButton(title: "채널 편집")
    let leaveButton = RoundedBorderButton(title: "채널에서 나가기")
    let changeAdminButton = RoundedBorderButton(title: "채널 관리자 변경")
    let deleteButton = RoundedBorderButton(title: "채널 삭제", color: .brandError)
    
    //그냥 멤버일때 버튼 -> leave Button -> remakeConstraints
    
    var isOwner: Bool = true

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setConstraints()
        
        contentView.backgroundColor = .backgroundPrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        [editButton, leaveButton, changeAdminButton, deleteButton].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        
        if isOwner {
            editButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(44)
            }
            
            leaveButton.snp.makeConstraints { make in
                make.top.equalTo(editButton.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(44)
            }
            
            changeAdminButton.snp.makeConstraints { make in
                make.top.equalTo(leaveButton.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(44)
            }
            
            deleteButton.snp.makeConstraints { make in
                make.top.equalTo(changeAdminButton.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(44)
            }
            
            editButton.isHidden = false
            changeAdminButton.isHidden = false
            deleteButton.isHidden = false
            
        } else {
            leaveButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(44)
            }
            
            editButton.isHidden = true
            changeAdminButton.isHidden = true
            deleteButton.isHidden = true
        }
        
    }
    
    
}


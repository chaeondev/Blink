//
//  InfoHeaderView.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class InfoHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel.labelBuilder(text: "#그냥 떠들고 싶을 때", font: .title2, textColor: .brandBlack)
    let infoLabel = UILabel.labelBuilder(text: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요", font: .body, textColor: .brandBlack)
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
}

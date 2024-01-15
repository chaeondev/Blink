//
//  UIViewController+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/15/24.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func setCustomNavigationbar(
        customView: UIView,
        left: UIButton,
        title: UIButton,
        right: UIButton
    ) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let height = navigationBar.frame.size.height
        let width = navigationBar.frame.size.width
        
        [left, title, right].forEach { customView.addSubview($0) }
        
        
        customView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        left.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        right.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(left.snp.trailing).offset(8)
            make.trailing.equalTo(right.snp.leading).offset(-8)
            make.centerY.equalTo(left)
        }
        
        navigationItem.titleView = customView

        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandWhite
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    func setCustomLargeTitleNavigation(title: String) {
        let titleLabel = UILabel.labelBuilder(text: title, font: .title1, textColor: .brandBlack)
        let titleView = UIView()
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    }
    
}

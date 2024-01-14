//
//  HomeEmptyViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeEmptyViewController: BaseViewController {
    
    private let mainView = HomeEmptyView()
    
    //Custom Navigation
    let customView = UIView()
    let leftButton = {
        let button = UIButton()
        button.setImage(.dummy, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    let naviTitleButton = {
        let button = UIButton()
        button.setTitle("No Workspace", for: .normal)
        button.setTitleColor(.brandBlack, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.title1)
        button.contentHorizontalAlignment = .left
        return button
    }()
    //let naviTitleLabel = UILabel.labelBuilder(text: "No Workspace", font: .title1, textColor: .brandBlack)
    let rightButton = {
        let button = UIButton()
        button.setImage(.noPhotoA, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.border.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
}

extension HomeEmptyViewController {
    func setNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let height = navigationBar.frame.size.height
        let width = navigationBar.frame.size.width
        
        [leftButton, naviTitleButton, rightButton].forEach { customView.addSubview($0) }
        
        
        customView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        naviTitleButton.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).offset(8)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8)
            make.centerY.equalTo(leftButton)
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
}

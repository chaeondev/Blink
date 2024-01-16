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

        setCustomNavigationbar(customView: customView, left: leftButton, title: naviTitleButton, right: rightButton)
    }
}


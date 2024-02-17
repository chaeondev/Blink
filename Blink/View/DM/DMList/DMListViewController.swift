//
//  DMListViewController.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit

final class DMListViewController: BaseViewController {
    
    private let mainView = DMListView()
    let viewModel = DMListViewModel()
    
    //Custom Navigation
    let customView = UIView()
    
    private lazy var leftButton = {
        let button = UIButton()
        button.setImage(.dummy, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var naviTitleButton = {
        let button = UIButton()
        button.setTitle("iOS Developers Study", for: .normal)
        button.setTitleColor(.brandBlack, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.title1)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var rightButton = {
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
        
        view.backgroundColor = .brandWhite
        
        setCustomNavigationbar(customView: customView, left: leftButton, title: naviTitleButton, right: rightButton)
        
    }
}

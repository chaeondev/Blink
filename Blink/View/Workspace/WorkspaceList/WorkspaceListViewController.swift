//
//  WorkspaceListViewController.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import UIKit



final class WorkspaceListViewController: BaseViewController {
    
    var viewType: WorkspaceListViewType!
    
    lazy var mainView = WorkspaceListView(viewType)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        setCustomLargeTitleNavigation(title: "워크스페이스")
        navigationItem.titleView?.backgroundColor = .blue
    }
    
    
}


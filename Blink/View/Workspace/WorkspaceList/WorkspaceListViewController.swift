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
        setView()
        setTableView()
        setCustomLargeTitleNavigation(title: "워크스페이스")
    }
    
    func setView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension WorkspaceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: WorkspaceListTableViewCell.description(), for: indexPath) as? WorkspaceListTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
}

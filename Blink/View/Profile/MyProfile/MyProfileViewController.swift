//
//  MyProfileViewController.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyProfileViewController: BaseViewController {
    
    private let mainView = MyProfileView()
    let viewModel = MyProfileViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "내 정보 수정")
        setTableView()
        
    }
    
    func bind() {
        
    }
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }

}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.description(), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.profileDataForCell(indexPath)
        
        cell.configureCell(data)
        
        return cell
    }
}

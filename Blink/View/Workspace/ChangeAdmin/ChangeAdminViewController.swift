//
//  ChangeAdminViewController.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeAdminViewController: BaseViewController {
    
    private let mainView = ChangeAdminView()
    let viewModel = ChangeAdminViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "워크스페이스 관리자 변경")
        setTableView()
        fetchData()
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func fetchData() {
        viewModel.fetchMembers { [weak self] isEmpty in
            if isEmpty {
                print("멤버 없음 -> 혼자 -> 얼럿")
                self?.showOneActionViewController(
                    title: "워크스페이스 관리자 변경 불가",
                    message: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요") {
                        self?.dismiss(animated: false) //alert dismiss
                        self?.dismiss(animated: true) // 관리자 변경 VC dismiss
                }
            } else {
                print("멤버 있음 -> TableView reload")
            }
        }
    }
}

extension ChangeAdminViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: AdminTableViewCell.description(), for: indexPath) as? AdminTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.items[indexPath.row]
        
        cell.configureCell(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 멤버 초대 한 다음에 추가하기
    }
}


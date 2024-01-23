//
//  ChangeAdminViewController.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChangeAdminDelegate: AnyObject {
    func sendToastMessage(_ message: String)
    func reloadWorkspaceList()
}

final class ChangeAdminViewController: BaseViewController {
    
    private let mainView = ChangeAdminView()
    let viewModel = ChangeAdminViewModel()
    
    //delegate
    weak var delegate: ChangeAdminDelegate?
    
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
                self?.mainView.tableView.reloadData()
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
        
        let data = viewModel.items[indexPath.row]
        self.showTwoActionViewController(
            title: "\(data.nickname) 님을 관리자로 지정하시겠습니까?",
            message: """
                    워크스페이스 관리자는 다음과 같은 권한이 있습니다.
                    • 워크스페이스 이름 또는 설명 변경
                    • 워크스페이스 삭제
                    • 워크스페이스 멤버 초대
                    """,
            doButtonTitle: "확인") {
                self.viewModel.changeAdmin(indexPath) { [weak self] msg in
                    self?.dismiss(animated: false)
                    self?.dismiss(animated: true) {
                        self?.delegate?.sendToastMessage(msg)
                        self?.delegate?.reloadWorkspaceList()
                    }
                }
            } cancelCompletion: {
                self.dismiss(animated: true)
            }

    }
}


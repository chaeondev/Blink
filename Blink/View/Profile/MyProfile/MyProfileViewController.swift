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
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "내 정보 수정", isLeftButton: false)
        setTableView()
        
        bind()
        fetchData()
    }
    
    func bind() {
        let input = MyProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.profileImageStr
            .bind(with: self) { owner, str in
                owner.mainView.profileButton.setKFImage(imageUrl: str, placeholderImage: .noPhotoB)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func fetchData() {
        viewModel.fetchProfileData { [weak self] in
            self?.mainView.tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let vc = CoinShopViewController()
            vc.viewModel.coinCnt = self.viewModel.coin
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

//
//  DMListViewController.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DMListViewController: BaseViewController {
    
    private let mainView = DMListView()
    let viewModel = DMListViewModel()
    
    private let disposeBag = DisposeBag()
    
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
        button.setTitle("Direct Message", for: .normal)
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
        
        fetchDMTableData()
        
        setCustomNavigationbar(customView: customView, left: leftButton, title: naviTitleButton, right: rightButton)
        
        setTableView()
        setCollectionView()

        bind()
        
        loadData()

    }
    
    func bind() {
        let input = DMListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        //네비게이션 leftButton, title 업데이트
        output.workspaceResource
            .bind(with: self) { owner, model in
                owner.leftButton.setKFImage(imageUrl: model.thumbnail, placeholderImage: .dummy)
            }
            .disposed(by: disposeBag)
        
        //프로필 조회 -> 네비게이션 rightButton 업데이트
        output.profileResource
            .bind(with: self) { owner, model in
                owner.rightButton.setKFImage(imageUrl: model.profileImage ?? "", placeholderImage: .noPhotoB)
            }
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func setCollectionView() {
        mainView.headerView.collectionView.delegate = self
        mainView.headerView.collectionView.dataSource = self
    }
    
    func loadData() {
        viewModel.reloadCompletion = { [weak self] in
            self?.mainView.headerView.collectionView.reloadData()
        }
    }
    
    func fetchDMTableData() {
        viewModel.fetchDMCellInfo {
            self.mainView.tableView.reloadData()
        }
    }
 
}

extension DMListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dmListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DMTableViewCell.description(), for: indexPath) as? DMTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.dmListData[indexPath.row]
        
        cell.configureCell(data)
        
        return cell
    }

}

extension DMListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memberListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.description(), for: indexPath) as? MemberCell else { return UICollectionViewCell() }
        
        let data = viewModel.memberListData[indexPath.item]
        cell.configureCell(name: data.nickname, imageUrl: data.profileImage)
        
        return cell
    }
}

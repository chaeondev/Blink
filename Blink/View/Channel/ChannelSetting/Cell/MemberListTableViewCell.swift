//
//  MemberListTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import SnapKit

final class MemberListTableViewCell: BaseTableViewCell {
    
    var items: [ChannelMemberRes] = []
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.description())
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func setHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(6)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setting() {
        self.selectionStyle = .none
    }
}

extension MemberListTableViewCell {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let size = UIScreen.main.bounds.width - 12 //horizontalEdges Spacing
        let width = size / 5
        let height = 90.0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
}

extension MemberListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.description(), for: indexPath) as? MemberCollectionViewCell else { return UICollectionViewCell() }
        
        let data = items[indexPath.item]
        
        cell.configureCell(name: data.nickname, imageUrl: data.profileImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: 프로필 이동 로직
    }
}

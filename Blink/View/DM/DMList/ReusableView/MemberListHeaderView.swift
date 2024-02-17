//
//  MemberListHeaderView.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import SnapKit

final class MemberListHeaderView: UITableViewHeaderFooterView {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(MemberCell.self, forCellWithReuseIdentifier: MemberCell.description())
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MemberListHeaderView {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.itemSize = CGSize(width: 76, height: 98)
        
        return layout
    }
}


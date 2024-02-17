//
//  MemberListHeaderView.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import UIKit
import SnapKit

final class MemberListHeaderView: UIView {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(MemberCell.self, forCellWithReuseIdentifier: MemberCell.description())
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let separatorView = {
        let view = UIView()
        view.backgroundColor = .seperator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setConstraints()
        
        self.backgroundColor = .brandWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(separatorView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(98)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(collectionView)
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


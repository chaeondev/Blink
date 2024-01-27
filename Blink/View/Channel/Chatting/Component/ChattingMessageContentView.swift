//
//  ChattingMessageContentView.swift
//  Blink
//
//  Created by Chaewon on 1/26/24.
//

import UIKit

final class ChattingMessageContentView: BaseView {
    
    //collectionView에 들어갈 아이템
    var imageFiles: [String] = []
    
    let userNameLabel = UILabel.labelBuilder(text: "옹골찬 고래밥", font: .caption, textColor: .brandBlack, numberOfLines: 1)
    let messageTextView = MessageBoxTextView(text: "저희 수료식이 언제였죠? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?")
    lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(ContentImageCollectionViewCell.self, forCellWithReuseIdentifier: ContentImageCollectionViewCell.description())
        view.layer.cornerRadius = 12
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .backgroundSecondary
        view.sizeToFit()
        return view
    }()
    
    override func setHierarchy() {
        
        [userNameLabel, messageTextView, photoCollectionView].forEach { self.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        userNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(18)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(244)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(5)
            make.width.equalTo(244)
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
    }
    
    //collectionView update
    func updateView(user: String, message: String, images: [String]) {
        
        self.userNameLabel.text = user
        self.messageTextView.text = message
        self.imageFiles = images
        
        let count = self.imageFiles.count
        
        //snapkit layout -> collectionView 높이
        self.remakeCollectionViewLayout(count)
        
        //compositional -> collectionView 내부 배치
        photoCollectionView.collectionViewLayout = setCollectionViewLayout(count)
        
        photoCollectionView.reloadData()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension ChattingMessageContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentImageCollectionViewCell.description(), for: indexPath) as? ContentImageCollectionViewCell else { return UICollectionViewCell() }
        
        let data = imageFiles[indexPath.item]
        cell.configureCell(imageUrl: data)
        
        return cell
    }
    
}

// MARK: collectionView layout
extension ChattingMessageContentView {
    
    func remakeCollectionViewLayout(_ cnt: Int) {
        
        var height: Int {
            switch cnt {
            case 1,4,5: return 162
            case 2,3: return 80
            default: return 0
            }
        }
        
        photoCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(5)
            make.width.equalTo(244)
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
    }
    
    
    func setCollectionViewLayout(_ cnt: Int) -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            
            guard let self else { return nil }
            
            switch cnt {
            case 1: return self.onePicLayout()
            case 2: return self.twoPicLayout()
            case 3: return self.threePicLayout()
            case 4: return self.fourPicLayout()
            case 5: return self.fivePicLayout()
            default: return nil
            }
            
        }
        
        return layout
    }
    
    func onePicLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func twoPicLayout() -> NSCollectionLayoutSection {
        
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingItem, trailingItem])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func threePicLayout() -> NSCollectionLayoutSection {
        
        let firstItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        firstItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        let secondItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        secondItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        let thirdItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [firstItem, secondItem, thirdItem])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func fourPicLayout() -> NSCollectionLayoutSection {
        let leadingItem1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        leadingItem1.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 2)
        let leadingItem2 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        
        let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingItem1, leadingItem2])
        
        let trailingItem1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        
        let trailingItem2 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        trailingItem2.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 0)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalHeight(1.0)),
            subitems: [trailingItem1, trailingItem2])
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingGroup, trailingGroup])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        return section
    }
    
    func fivePicLayout() -> NSCollectionLayoutSection {
        let firstItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        firstItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 2)
        
        let secondItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        secondItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 2)
        
        let thirdItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)))
        thirdItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0)
        
        let topGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [firstItem, secondItem, thirdItem])
        
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        
        let downGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [leadingItem, trailingItem])
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [topGroup, downGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        return section
    }
    
}

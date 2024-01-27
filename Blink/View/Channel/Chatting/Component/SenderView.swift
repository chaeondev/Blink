//
//  SenderView.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import UIKit

final class SenderView: BaseView {
    
    var photoItems: [String] = []
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.sizeToFit()
        return view
    }()
    
    let plusButton = {
        let view = UIButton()
        view.setImage(.plus, for: .normal)
        return view
    }()
    
    let sendButton = SendButton()
    
    let textView = SenderTextView(placeholder: "메세지를 입력하세요")
    
    lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(SendPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SendPhotoCollectionViewCell.description())
        view.backgroundColor = .backgroundPrimary
        
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    lazy var stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .bottom
        view.spacing = 8
        return view
    }()
    
    override func setHierarchy() {
        [textView, photoCollectionView].forEach { stackView.addArrangedSubview($0) }
        [plusButton, sendButton, stackView].forEach { backView.addSubview($0) }
        [backView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(42)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(52)
            make.bottom.equalTo(photoCollectionView.snp.top).offset(-8)
        }
    }
    
    override func setting() {
        super.setting()
        self.backgroundColor = .brandWhite
    }
    
    func updateView(images: [String]) {
        self.photoItems = images
        let count = self.photoItems.count
        
        photoCollectionView.isHidden = (count == 0) ? true : false
        photoCollectionView.reloadData()
    }
}

extension SenderView {
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 50, height: 50)
        return layout
    }
}

extension SenderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SendPhotoCollectionViewCell.description(), for: indexPath) as? SendPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

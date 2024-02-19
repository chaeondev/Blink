//
//  ProfileTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    let appleImageView = {
        let view = UIImageView()
        view.image = .apple
        return view
    }()
    
    let kakaoImageView = {
        let view = UIImageView()
        view.image = .kakao
        return view
    }()
    
    let stackView = {
        let view = UIStackView()
        view.frame = CGRect(x: 0, y: 0, width: 45, height: 20)
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .trailing
        view.spacing = 4
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        [appleImageView, kakaoImageView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        appleImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        kakaoImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    private func setting() {
        self.textLabel?.text = "닉네임"
        self.textLabel?.font = .customFont(.bodyBold)
        
        self.detailTextLabel?.text = "옹골찬 고래밥"
        self.detailTextLabel?.textColor = .textSecondary
        self.detailTextLabel?.font = .customFont(.body)
        
        contentView.backgroundColor = .backgroundSecondary
    }
    
    func configureCell(_ data: ProfileCellInfo) {
        
        //Title Text
        if data.isAttributedString {
            self.textLabel?.textColor = .brandGreen
            
            let attributedStr = NSMutableAttributedString(string: data.title)
            attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: (data.title as NSString).range(of: "내 새싹 코인"))
            
            self.textLabel?.attributedText = attributedStr
        } else {
            self.textLabel?.text = data.title
        }
        
        //Detail Text
        self.detailTextLabel?.text = data.detail
        
        //Accessory
        switch data.accessory {
        case .none:
            self.accessoryType = .none
        case .disclosure:
            self.accessoryType = .disclosureIndicator
        case .custom(let socialList):
            appleImageView.isHidden = socialList.contains(.apple) ? false : true
            kakaoImageView.isHidden = socialList.contains(.kakao) ? false : true
            
            self.accessoryView = stackView
        }
    }
}

struct ProfileData {
    var first: [ProfileCellInfo]
    var second: [ProfileCellInfo]
}

struct ProfileCellInfo {
    var title: String
    var isAttributedString: Bool = false
    var detail: String?
    var accessory: AccessoryType
}

enum AccessoryType {
    case none
    case disclosure
    case custom(_ socialList: [SocialType])
}

enum SocialType {
    case kakao
    case apple
}

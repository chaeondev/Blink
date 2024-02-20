//
//  CoinShopTableViewCell.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import UIKit
import SnapKit
import RxSwift

final class CoinShopTableViewCell: UITableViewCell {
    
    let moneyButton = MoneyButton(money: 100)
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setting() {
        self.textLabel?.text = "현재 보유한 코인 330개"
        self.textLabel?.font = .customFont(.bodyBold)
        
        self.detailTextLabel?.text = "코인이란?"
        self.detailTextLabel?.textColor = .textSecondary
        self.detailTextLabel?.font = .customFont(.body)
        
        contentView.backgroundColor = .backgroundSecondary
        self.selectionStyle = .none
    }
    
    func configureCell(_ data: CoinCellData) {
        //Title Text
        if data.isAttributedStr {
            self.textLabel?.textColor = .brandGreen
            
            let attributedStr = NSMutableAttributedString(string: data.title)
            attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: (data.title as NSString).range(of: "현재 보유한 코인"))
            
            self.textLabel?.attributedText = attributedStr
        } else {
            self.textLabel?.textColor = .brandBlack
            self.textLabel?.text = data.title
        }
        
        //Detail Text
        self.detailTextLabel?.text = data.detail
        
        //Accessory
        switch data.isAccessoryView {
        case .none:
            self.accessoryView = nil
        case .custom(let money):
            moneyButton.setTitle("₩\(money)", for: .normal)
            moneyButton.frame = CGRect(x: 0, y: 0, width: 74, height: 28)
            self.accessoryView = moneyButton
        }
    }
}

struct CoinTableData {
    var first: [CoinCellData]
    var second: [CoinCellData]
}

struct CoinCellData {
    var title: String
    var isAttributedStr: Bool = false
    var detail: String?
    var isAccessoryView: isAccesory
}

enum isAccesory {
    case none
    case custom(_ money: Int)
}

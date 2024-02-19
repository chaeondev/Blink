//
//  CoinShopViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import Foundation

final class CoinShopViewModel: ViewModelType {
    
    var coinCnt = -1
    
    lazy var coinTableData = CoinTableData(
        first: [
            CoinCellData(title: "🌱 현재 보유한 코인 \(coinCnt)개", isAttributedStr: true, detail: "코인이란?", isAccessoryView: .none)
        ],
        second: [
            CoinCellData(title: "🌱 10 Coin", isAccessoryView: .custom(100)),
            CoinCellData(title: "🌱 50 Coin", isAccessoryView: .custom(500)),
            CoinCellData(title: "🌱 100 Coin", isAccessoryView: .custom(1000))
        ]
    )
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension CoinShopViewModel {
    
    func coinDataForCell(_ indexPath: IndexPath) -> CoinCellData {
        switch indexPath.section {
        case 0:
            return coinTableData.first[indexPath.row]
        case 1:
            return coinTableData.second[indexPath.row]
        default:
            return CoinCellData(title: "오류오류", isAccessoryView: .none)
        }
    }
}

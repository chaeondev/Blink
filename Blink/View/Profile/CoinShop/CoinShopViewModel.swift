//
//  CoinShopViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

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
        let cellButtonClicked: PublishSubject<IndexPath>
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

// MARK: 결제 관련
extension CoinShopViewModel {
    
    //1. 결제 요청 데이터 구성
    func createPaymentData(_ title: String?) -> IamportPayment {
        var amount = ""
        var coin = -1
        
        if let title {
            amount = title.replacingOccurrences(of: "₩", with: "")
            coin = (Int(amount) ?? 10)/10
            print("AMOUNT: \(amount), COIN: \(coin)")
        } else {
            print("버튼에서 amount 못구함!!!!!!")
            print("coin도 못구함!!!!!!!!!!")
        }
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: amount).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = "\(coin) coin"
                $0.buyer_name = "윤채원"
                $0.app_scheme = "sesac"
            }
        
        return payment
    }
}

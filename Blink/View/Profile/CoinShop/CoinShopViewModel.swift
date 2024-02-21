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
                $0.name = "\(coin) Coin"
                $0.buyer_name = "윤채원"
                $0.app_scheme = "sesac"
            }
        
        return payment
    }
    
    func validPayment(_ iamportResponse: IamportResponse?, completion: @escaping (Int) -> Void) {
        guard let iamportResponse else { return }
        
        let requestModel = PayValidationRequest(imp_uid: iamportResponse.imp_uid ?? "결제거래번호 없음", merchant_uid: iamportResponse.merchant_uid ?? "상점고유번호 없음")
        
        print("======유효성 requestModel======\n", requestModel)
        
        APIService.shared.requestCompletion(type: BillingResultRes.self, api: UserRouter.payValidation(requestModel)) { result in
            switch result {
            case .success(let response):
                print("\n=======결제 유효성 검사 성공!!!=======")
                print("\n\n", response, "\n")
                
                let coin = response.sesacCoin
                completion(coin)
                
            case .failure(let error):
                print("=====결제 유효성 검사 에러!!!=====")
                print(error)
            }
        }
    }
    
    func updateProfileCoin(completion: @escaping () -> Void) {
        
        APIService.shared.requestCompletion(type: ProfileRes.self, api: UserRouter.checkMyProfile) { result in
            switch result {
            case .success(let response):
                print("프로필 새싹 코인 업데이트 성공")
                let totalCoin = response.sesacCoin
                self.coinTableData.first[0].title = "🌱 현재 보유한 코인 \(totalCoin)개"
                completion()
            case .failure(let error):
                print("프로필 새싹 코인 업데이트 실패")
            }
        }
    }
}

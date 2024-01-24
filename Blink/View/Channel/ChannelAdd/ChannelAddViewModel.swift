//
//  ChannelAddViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelAddViewModel: ViewModelType {
    
    enum ChannelResult {
        case success
        case serverConflict
        case noData
        case wrongRequest
    }
    
    var workspaceID: Int = 0
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptText: ControlProperty<String>
        let createButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let networkResult: PublishSubject<ChannelResult>
    }
    
    func transform(input: Input) -> Output {
        
        let networkResult = PublishSubject<ChannelResult>()
        
        //구조체
        let requestModel = Observable.combineLatest(input.nameText, input.descriptText)
            .map { (name, descript) in
                return CreateChannelRequest(name: name, description: descript)
            }
        
        //생성버튼 tap
        input.createButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.nameText)
            .filter { !$0.isEmpty }
            .withLatestFrom(requestModel)
            .flatMapLatest {
                APIService.shared.request(type: ChannelRes.self, api: ChannelRouter.createChannel(self.workspaceID, $0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===Create Channel \(response.channel_id) success===")
                    networkResult.onNext(.success)
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : CreateChannelError(rawValue: error.errorCode)
                    
                    if let wsError = customError as? CreateChannelError {
                        switch wsError {
                        case .serverConflict:
                            networkResult.onNext(.serverConflict)
                        case .noData:
                            networkResult.onNext(.noData)
                        case .wrongRequest:
                            networkResult.onNext(.wrongRequest)
                        }
                    }
                    
                    print("==Create Channel Failed \(String(describing: customError))")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(networkResult: networkResult)
    }
}

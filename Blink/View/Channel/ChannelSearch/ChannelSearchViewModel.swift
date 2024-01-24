//
//  ChannelSearchViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelSearchViewModel: ViewModelType {
    
    var workspaceID: Int = 0
    var selectedItem: ChannelRes?
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadData: PublishSubject<Void>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let items: PublishSubject<[ChannelRes]>
        let isjoined: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let items = PublishSubject<[ChannelRes]>()
        let isjoined = PublishSubject<Bool>()
       
        //Table구성하는 Items
        input.loadData
            .flatMapLatest {
                APIService.shared.request(type: [ChannelRes].self, api: ChannelRouter.checkAllChannels(self.workspaceID))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===채널 리스트 네트워크 성공===")
                    items.onNext(response)
                    
                case .failure(let error):
                    let customError = NetworkError(rawValue: error.errorCode)
                    print("===채널 리스트 네트워크 실패=== \(String(describing: customError))")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        //테이블 셀 selected event -> 내가 join한 채널과 아닌 채널 구분
        input.itemSelected
            .withLatestFrom(items) { index, items in
                
                self.selectedItem = items[index.row]
                
                return self.selectedItem
            }
            .flatMapLatest { _ in
                APIService.shared.request(type: [ChannelRes].self, api: ChannelRouter.checkMyChannels(self.workspaceID))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let myChannels):
                    print("===내 채널 목록 네트워크 성공===")
                    guard let selectedItem = owner.selectedItem else { return }
                    
                    let bool = myChannels.contains {
                        $0.channel_id == selectedItem.channel_id
                    }
                    isjoined.onNext(bool)
                    
                case .failure(let error):
                    print("===내 채널 목록 네트워크 실페 \(error)===")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(items: items, isjoined: isjoined)
    }
}

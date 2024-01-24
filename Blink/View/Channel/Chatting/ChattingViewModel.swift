//
//  ChattingViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel: ViewModelType {
    
    var workspaceID: Int = 0
    var channelInfo: ChannelRes!
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension ChattingViewModel {
    
    func loadData(completion: @escaping () -> Void) {
        fetchAllChatting {
            completion()
        }
    }
    
    func fetchAllChatting(completion: @escaping () -> Void) {
        
        let requestModel = ChattingRequest(
            workspaceID: self.workspaceID,
            channelName: self.channelInfo.name,
            cursor_date: "" // MARK: 우선 전체 채팅 내역 불러옴 -> 나중에 바꿀 필요 있음
        )
        
        APIService.shared.requestCompletion(type: [ChannelChatRes].self, api: ChannelRouter.fetchChatting(requestModel)) { result in
            switch result {
            case .success(let response):
                print("===채팅 내역 불러옵니다!!! 전체 내역입니다!!! \n\(response)\n===")
                completion()
            case .failure(let error):
                print("===채팅 내역 못불러옴ㅜㅜ===")
            }
        }
    }
}

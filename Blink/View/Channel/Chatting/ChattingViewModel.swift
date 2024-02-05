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
    
    var lastDate: Date? // cursor_date의 기준이 되는 날짜-> Realm의 마지막 날짜 (안읽은 채팅 기준 날짜)
    var chatInfoList: [ChattingInfoModel] = [] //TableView에 사용될 채팅 인포 리스트
    
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

//TableView 관련 메서드
extension ChattingViewModel {
    
    func numberOfRowsInSection() -> Int {
        return chatInfoList.count
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> ChattingInfoModel {
        return chatInfoList[indexPath.row]
    }
}

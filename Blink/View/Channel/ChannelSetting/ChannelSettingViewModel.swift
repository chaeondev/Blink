//
//  ChannelSettingViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelSettingViewModel {
    
    //workspaceID, ChannelName 전달받은 값
    var channelInfo: ChannelRes!
    
    //채널 -> TableView에 사용할 데이터
    var channelData: SpecificChannelRes?
    
    //section open 여부
    var isOpened = true
    
    //관리자 여부
    var isOwner = false
    
    func fetchData(completion: @escaping () -> Void) {
        
        APIService.shared.requestCompletion(type: SpecificChannelRes.self, api: ChannelRouter.checkChannelInfo(channelInfo.workspace_id, channelInfo.name)) { result in
            switch result {
            case .success(let response):
                self.channelData = response
                
                print("===채널 정보 업데이트~~ 테이블 뷰 그릴 수 있음===")
                print(response)
                
                if "\(response.owner_id)" == KeyChainManager.shared.userID {
                    self.isOwner = true
                } else {
                    self.isOwner = false
                }
                
                completion()
                
            case .failure(let error):
                print("===채널 정보 에러~~ \(error)===")
            }
        }
    }
}

extension ChannelSettingViewModel {
    
    func infoForSection() -> SectionData {
        
        guard let channelData else { return SectionData(count: -1, expanded: false) }
        
        return SectionData(
            count: channelData.channelMembers.count,
            expanded: self.isOpened
        )
    }
    
    func infoForMemberCell() -> [ChannelMemberRes] {
        
        guard let channelData else { return [] }
        
        return channelData.channelMembers
    }
    
    func toggleSection(_ indexPath: IndexPath, completion: @escaping () -> Void) {
        
        if indexPath.row == 0 {
            isOpened.toggle()
            completion()
        }
    }
}

struct SectionData {
    let count: Int
    let expanded: Bool
}

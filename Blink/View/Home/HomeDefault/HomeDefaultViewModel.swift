//
//  HomeDefaultViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeChannelsData {
    let title: String = "채널"
    var opened: Bool
    var sectionData: [ChannelCellInfo]
    
    struct ChannelCellInfo {
        let channelInfo: ChannelRes
        var unreadChatCnt: Int
    }
}

struct HomeDMsData {
    let title: String = "다이렉트 메시지"
    var opened: Bool
    var sectionData: [DMCellInfo]
    
    struct DMCellInfo {
        let dmInfo: DMsRoomRes
        var unreadDMCnt: Int
    }
}

final class HomeDefaultViewModel: ViewModelType {
    
    var workspaceID: Int = 0 //전달값! 이거 없으면 view 못그림
    
    private var disposeBag = DisposeBag()
    
    //TableView Data
    var channelData = BehaviorRelay<HomeChannelsData>(value: HomeChannelsData(opened: false, sectionData: []))
    var dmData = BehaviorRelay<HomeDMsData>(value: HomeDMsData(opened: false, sectionData: []))
    
    struct Input {

    }
    
    struct Output {
        let workspaceResource: PublishSubject<WorkspaceRes>
        let profileResource: PublishSubject<ProfileRes>
    }
    
    func transform(input: Input) -> Output {
        
        let workspaceResource = PublishSubject<WorkspaceRes>()
        let profileResource = PublishSubject<ProfileRes>()
        
        // MARK: 워크스페이스 정보 조회
        APIService.shared.request(type: WorkspaceRes.self, api: WorkspaceRouter.checkOneWorkspaceInfo(self.workspaceID))
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===워크스페이스 한개 정보 조회 성공===")
                    workspaceResource.onNext(response)
                case .failure(let error):
                    print("===워크스페이스 한개 정보 조회 실패===")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 프로필 조회
        APIService.shared.request(type: ProfileRes.self, api: UserRouter.checkMyProfile)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===프로필 조회 성공===")
                    profileResource.onNext(response)
                case .failure(let error):
                    print("===프로필 조회 실패===")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
       
        
        return Output(workspaceResource: workspaceResource, profileResource: profileResource)
    }
    
    //bind에 넣기에는 reload table을 또 어떻게 전달해야할 지 모르겠음 그럴바에는 메서드로 빼자
    func fetchChannelTableData() {
        // MARK: 채널 정보조회
        APIService.shared.request(type: [ChannelRes].self, api: ChannelRouter.checkMyChannels(self.workspaceID))
            .subscribe(with: self) { owner, result in
                switch result {
                    
                case .success(let response):
                    print("===내 채널 정보 조회 성공===")
                    let data = HomeChannelsData(
                        opened: true,
                        sectionData: response.map {
                            HomeChannelsData.ChannelCellInfo(channelInfo: $0, unreadChatCnt: 10)
                        }
                    )
                    
                    self.channelData.accept(data)
                    
                case .failure(let error):
                    
                    print("===내 채널 정보 조회 실패 -> 채팅갯수 네트워크 연결 안함===")
                    print(error)
                    
                    //sectionData가 빈배열인 것을 전달 -> failure인것 파악 가능
                    let data = HomeChannelsData(opened: true, sectionData: [])
                    self.channelData.accept(data)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 읽지 않은 채팅 갯수 조회
        
        //구조체 만들기
        self.channelData
            .filter { !$0.sectionData.isEmpty } // 채널 정보 조회 실패시 request 구조체 자체를 안만들어 버림
            .map {
                for (index, item) in $0.sectionData.enumerated() {
                    let requestModel = ChannelUnreadCountRequest(
                        workspaceID: item.channelInfo.workspace_id,
                        channelName: item.channelInfo.name,
                        after: item.channelInfo.createdAt // TODO: 현재는 생성 시점부터 읽지않은걸로 처리!! 꼭꼭 바꾸기!!
                    )
                    
                    //네트워크 통신
                    APIService.shared.request(type: ChannelUnreadCountResponse.self, api: ChannelRouter.channelChatUnreadCount(requestModel))
                        .subscribe(with: self) { owner, result in
                            switch result {
                            case .success(let response):
                                print("===\(response.name) 채널 읽지 않은 채팅 개수: \(response.count) 네트워크 성공===")
                                var value = owner.channelData.value
                                value.sectionData[index].unreadChatCnt = response.count
                                
                                owner.channelData.accept(value)
                            case .failure(let error):
                                var value = owner.channelData.value
                                print("===채널 읽지 않은 채팅 개수 네트워크 실패===")
                                print("===채널 정보: \(value.sectionData[index].channelInfo)===")
                                print("===에러: \(error)===")
                            }
                        }
                        .disposed(by: self.disposeBag)
                    
                }
                
                return $0
            }
            .subscribe(with: self) { owner, data in
                print("===channelData===", data)
            }
            .disposed(by: disposeBag)
      
    }
}

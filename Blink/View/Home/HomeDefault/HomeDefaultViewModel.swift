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
    var channelData: HomeChannelsData?
    var dmData: HomeDMsData?
    
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
    
    
    func fetchChannelInfo(completion: @escaping () -> Void) {
        APIService.shared.requestCompletion(type: [ChannelRes].self, api: ChannelRouter.checkMyChannels(self.workspaceID)) { [weak self] result in
            switch result {
            case .success(let response):
                print("===내 채널 정보 조회 성공===")
                self?.channelData = HomeChannelsData(
                    opened: true,
                    sectionData: response.map {
                        HomeChannelsData.ChannelCellInfo(channelInfo: $0, unreadChatCnt: 10)
                    }
                )
                
                self?.fetchChannelUnreadCount {
                    completion()
                }
            case .failure(let error):
                print("===내 채널 정보 조회 실패 -> 채팅갯수 네트워크 연결 안함===")
                print(error)
            }
        }
    }
    
    func fetchChannelUnreadCount(completion: @escaping () -> Void) {
        guard let channelData else { return }
        
        for (index, item) in channelData.sectionData.enumerated() {
            let requestModel = ChannelUnreadCountRequest(
                workspaceID: self.workspaceID,
                channelName: item.channelInfo.name,
                after: item.channelInfo.createdAt // TODO: 현재는 생성 시점부터 읽지않은걸로 처리!! 꼭꼭 바꾸기!!
            )
            
            APIService.shared.requestCompletion(type: ChannelUnreadCountResponse.self, api: ChannelRouter.channelChatUnreadCount(requestModel)) { [weak self] result in
                switch result {
                case .success(let response):
                    print("===\(response.name) 채널 읽지 않은 채팅 개수: \(response.count) 네트워크 성공===")
                    self?.channelData!.sectionData[index].unreadChatCnt = response.count
                    
                    completion()
                case .failure(let error):
                    print("===채널 읽지 않은 채팅 개수 네트워크 실패===")
                    print("===채널 정보: \(String(describing: self?.channelData?.sectionData[index].channelInfo))===")
                    print("===에러: \(error)===")
                }
            }
            
        }
    }
    
    func fetchDMInfo(completion: @escaping () -> Void) {
        APIService.shared.requestCompletion(type: [DMsRoomRes].self, api: DMSRouter.checkDMRooms(self.workspaceID)) { [weak self] result in
            switch result {
            case .success(let response):
                print("===DM 정보 조회 성공 ===")
                self?.dmData = HomeDMsData(
                    opened: true,
                    sectionData: response.map {
                        HomeDMsData.DMCellInfo(dmInfo: $0, unreadDMCnt: 10)
                    }
                )
                
            case .failure(let error):
                print("===DM 정보 조회 실패 ===", error)
            }
        }
    }
    
    func fetchDMsUnreadCount(completion: @escaping () -> Void) {
        guard let dmData else { return }
        
        for (index, item) in dmData.sectionData.enumerated() {
            let requestModel = DMsUnreadCountRequest(
                roomID: item.dmInfo.room_id,
                workspaceID: self.workspaceID,
                after: item.dmInfo.createdAt) // TODO: 꼭 바꾸기!!!
            
            APIService.shared.requestCompletion(type: DMsUnreadCountResponse.self, api: DMSRouter.dmsUnreadCount(requestModel)) { [weak self] result in
                switch result {
                case .success(let response):
                    print("===\(response.room_id) 방 DM개수: \(response.count) 네트워크 성공===")
                    self?.dmData!.sectionData[index].unreadDMCnt = response.count
                    
                    completion()
                case .failure(let error):
                    print("===DM 읽지 않은 채팅 개수 네트워크 실패===")
                    print("===DM방 정보: \(String(describing: self?.dmData?.sectionData[index].dmInfo))")
                    print("===에러: \(error)===")
                }
            }
        }
    }
    
    
}

enum HomeCellType {
    case chevronCell
    case channelCell
    case dmCell
    case plusCell
}

// MARK: TableView 관련 메서드
extension HomeDefaultViewModel {
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        guard let channelData, let dmData else { return 0 }
        
        switch section {
        case 0:
            return (channelData.opened) ? channelData.sectionData.count + 2 : 1
        case 1:
            return (dmData.opened) ? dmData.sectionData.count + 2 : 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func checkCellType(indexPath: IndexPath) -> HomeCellType {
        guard let channelData, let dmData else { return .plusCell }
        
        switch (indexPath.section, indexPath.row) {
        case (0,0), (1,0):
            return .chevronCell
        case (0, channelData.sectionData.count + 1), (1, dmData.sectionData.count + 1):
            return .plusCell
        case (0, _):
            return .channelCell
        case (1, _):
            return .dmCell
        default:
            return .plusCell
        }
    }
    
    func chevronData(indexPath: IndexPath) -> ChevronData {
        guard let channelData, let dmData else { return ChevronData(title: "", opened: false) }
        if indexPath.section == 0 {
            
            let data = ChevronData(title: channelData.title, opened: channelData.opened)
            
            return data
        } else {
            
            let data = ChevronData(title: dmData.title, opened: dmData.opened)
            
            return data
        }
    }
    
    func channelData(indexPath: IndexPath) -> ChannelData {
        guard let channelData else { return ChannelData(title: "", count: 0) }
        
        let data = channelData.sectionData[indexPath.row - 1]
        
        return ChannelData(title: data.channelInfo.name, count: data.unreadChatCnt)
    }
    
    func dmData(indexPath: IndexPath) -> DMdata {
        guard let dmData else { return DMdata(image: nil, title: "", count: 0) }
        
        let data = dmData.sectionData[indexPath.row - 1]
        
        return DMdata(image: data.dmInfo.user.profileImage, title: data.dmInfo.user.nickname, count: data.unreadDMCnt)
    }
    
    func toggleSection(indexPath: IndexPath, completion: @escaping () -> Void) {
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                channelData?.opened.toggle()
                completion()
            } else if indexPath.section == 1 {
                dmData?.opened.toggle()
                completion()
            }
        }
    }
}

struct ChevronData {
    let title: String
    let opened: Bool
}

struct ChannelData {
    let title: String
    let count: Int
}
    
struct DMdata {
    let image: String?
    let title: String
    let count: Int
}
    

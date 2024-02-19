//
//  DMListViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMListViewModel: ViewModelType {
    
    var workspaceID = -1
    
    private let disposeBag = DisposeBag()
    
    var memberListData: [User] = []
    var dmListData: [DMListCellInfo] = []
    
    //collectionView reload 위한것
    var reloadCompletion: (() -> Void)?
    
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
                    
                    // TODO: 여기서 reload를 해줘야하는건가..? 어케해ㅜ completion이 아니어서 모르겠음..
                    owner.memberListData = response.workspaceMembers.filter { "\($0.user_id)" != KeyChainManager.shared.userID }
                    owner.reloadCompletion?()
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
        
        return Output(
            workspaceResource: workspaceResource,
            profileResource: profileResource
        )
    }

}

extension DMListViewModel {
    
    func fetchDMCellInfo(completion: @escaping () -> Void) {
        self.fetchDMRoomData {
            
            self.fetchDMRecentChatting {
                
                self.fetchDMsUnreadCount {
                    completion()
                }
            }
        }
    }
    
    func fetchDMRoomData(completion: @escaping () -> Void) {
        APIService.shared.requestCompletion(type: [DMsRoomRes].self, api: DMSRouter.checkDMRooms(self.workspaceID)) { [weak self] result in
            switch result {
            case .success(let response):
                print("===DM 정보 조회 성공 ===")
                
                self?.dmListData = response.map {
                    DMListCellInfo(
                        roomID: $0.room_id, 
                        roomCreatedAt: $0.createdAt,
                        userID: $0.user.user_id,
                        profileImage: $0.user.profileImage,
                        nickname: $0.user.nickname,
                        content: "아직 업데이트 안됨",
                        date: Date(),
                        messageCnt: -1
                    )
                }
                
                completion()
                
            case .failure(let error):
                print("===DM 정보 조회 실패 ===")
                print(error)
            }
        }
    }
    
    func fetchDMRecentChatting(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        for (index, item) in dmListData.enumerated() {
            let requestModel = DMChattingRequest(
                userID: item.userID,
                workspaceID: self.workspaceID,
                cursor_date: "" // TODO: 나중에 바꾸기!!
            )
            
            group.enter()
            APIService.shared.requestCompletion(type: DMsChatsRes.self, api: DMSRouter.fetchDMChatting(requestModel)) { [weak self] result in
                switch result {
                case .success(let response):
                    print("===WORKSPACE ID \(response.workspace_id)===")
                    print("===DM ROOM Number \(response.room_id)===")
                    print("=======DM 최근 채팅 불러오기 성공~~=======")
                    
                    let chatCnt = response.chats.count
                    if chatCnt != 0 {
                        let recentChat = response.chats[chatCnt - 1]
                        self?.dmListData[index].content = recentChat.content ?? "사진"
                        self?.dmListData[index].date = recentChat.createdAt.toDate(dateType: .apiDate)!
                    } else {
                        self?.dmListData[index].content = ""
                        self?.dmListData[index].date = Date()
                    }
                    
                    
                case .failure(let error):
                    print("\nDM 최근 채팅 불러오기 실패")
                    print(error)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func fetchDMsUnreadCount(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        for (index, item) in dmListData.enumerated() {
            let requestModel = DMsUnreadCountRequest(
                roomID: item.roomID,
                workspaceID: self.workspaceID,
                after: item.roomCreatedAt // TODO: 나중에 바꾸기!
            )
            
            group.enter()
            APIService.shared.requestCompletion(type: DMsUnreadCountResponse.self, api: DMSRouter.dmsUnreadCount(requestModel)) { [weak self] result in
                switch result {
                case .success(let response):
                    print("===\(response.room_id) 방 DM개수: \(response.count) 네트워크 성공===")
                    self?.dmListData[index].messageCnt = response.count
                    
                case .failure(let error):
                    print("===DM 읽지 않은 채팅 개수 네트워크 실패===")
                    print(error)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

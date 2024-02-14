//
//  ChattingViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

// failure시 채팅 다시보내기 -> RequestModel이 필요함 -> 나중에 하자.. -> VC에서 하는일 있음..
enum SendChattingResult {
    case success // 어차피 DB에만 저장하고 업데이트하니까 response 보낼 필요없음?
    case failure
}

final class ChattingViewModel: ViewModelType {
    
    //전달값
    var workspaceID: Int = 0
    var channelInfo: ChannelRes!
    
    //Rx DisposeBag
    private var disposeBag = DisposeBag()
    
    //Realm Repository
    private let chatRepository = RealmRepository()
    
    var lastDate: Date? // cursor_date의 기준이 되는 날짜-> Realm의 마지막 날짜 (안읽은 채팅 기준 날짜)
    var chatInfoList: [ChattingInfoModel] = [] //TableView에 사용될 채팅 인포 리스트
    var scrollIndex: Int = -1 //진입했을때 스크롤 시점 -> 새 메세지가 많을때는 새메세지 최신거말고 오래된거부터 읽을 수 있게
    
    //senderView POST할 photoItems
    let photoItems: BehaviorRelay<[Data]> = BehaviorRelay(value: [])
    
    //Socket으로 전달받는 newChat
    var newChat = PublishSubject<ChattingInfoModel>()
    
    struct Input {
        let contentText: ControlProperty<String>
        let sendButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let sendButtonEnable: BehaviorSubject<Bool>
        let sendChatResult: PublishSubject<SendChattingResult>
        let newChat: PublishSubject<ChattingInfoModel>
    }
    
    func transform(input: Input) -> Output {
        
        let checkText = BehaviorSubject(value: false)
        let checkImage = BehaviorSubject(value: false)
        let sendButtonEnable = BehaviorSubject(value: false)
        let sendChatResult = PublishSubject<SendChattingResult>()
        
        // MARK: send button Enable 여부 체크
        input.contentText
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 != "메세지를 입력하세요" }
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .bind(to: checkText)
            .disposed(by: disposeBag)
        
        photoItems
            .map { !$0.isEmpty }
            .bind(to: checkImage)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(checkText, checkImage)
            .map { $0 || $1 }
            .bind(to: sendButtonEnable)
            .disposed(by: disposeBag)
        
        // MARK: 채팅 POST 네트워크 통신
        
        let realText = input.contentText
            .filter { $0 != "메세지를 입력하세요" }
        
        let requestModel = Observable.combineLatest(input.contentText, photoItems)
            .map { (text, photos) in
                return SendChattingRequest(
                    workspaceID: self.workspaceID,
                    channelName: self.channelInfo.name,
                    content: (text != "메세지를 입력하세요") ? text : "",
                    files: photos
                )
            }
        
        input.sendButtonTapped
            .withLatestFrom(requestModel)
            .flatMapLatest {
                APIService.shared.requestMultipart(type: ChannelChatRes.self, api: ChannelRouter.sendChatting($0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("====SEND CHAT SUCCESS====")
                    print(response)
                    
                    //1. 성공시 응답값 DB 저장 -> 업데이트?
                    //2. 테이블뷰 리스트에 append
                    //3. 성공여부 VC에 전달
                    //4. 테이블 뷰 갱신
                    //5. 스크롤 맨밑으로 보내기? -> 이게 맞나? 고민
                    //6. senderView 초기화
                    
                    ///잠시만 생각해보자.. DB에 업데이트 하고 테이블 리로드 한다고 바로 추가되는게 아니잖아..?
                    ///DB 업데이트 -> 테이블 재료 업데이트 -> 테이블 리로드 이게 맞단 말이지?
                    ///근데 생각해보면 그렇게했을때..DB를 전체 fetch해야하나?너무 부담..
                    ///차라리 바로 append를 하고..DB에도 저장하고..아 어렵.. 소켓통신도 있잖아...
                    
                    //1.
                    owner.chatRepository.addChat(chatInfo: response, workspaceID: owner.workspaceID)
                    
                    //2.
                    let newChat = owner.switchModelToInfo(response)
                    owner.chatInfoList.append(newChat)
                    
                    //3.
                    sendChatResult.onNext(.success)
                    
                case .failure(let error):
                    print("====SEND CHAT FAILED====")
                    print(error)
                    
                    sendChatResult.onNext(.failure)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: Socket 통신
        
        //소켓으로 전달받은 데이터 -> 테이블리스트에 추가
        self.newChat
            .bind(with: self) { owner, chatInfo in
                owner.chatInfoList.append(chatInfo)
            }
            .disposed(by: disposeBag)
        
        
        return Output(sendButtonEnable: sendButtonEnable, 
                      sendChatResult: sendChatResult,
                      newChat: self.newChat)
    }
    
    func loadData(completion: @escaping () -> Void) {
        
        
        //1. DB 가장 마지막 날짜 체크
        self.checkLastChatDate()
        
        //2. DB 마지막 채팅 index 확인 -> 스크롤 시점 또는 구분셀 넣을 수 있음
        // DB저장된 거 없으면 -1
        self.checkDBChatLastIndex()
        
        //3. 네트워크 콜 GET -> DB 저장
        self.fetchRecentChatting {
            
            //4. DB 저장된 채팅 내역 가져오기 -> append아니고 아예 allDB여서 교체함 나중에 수정해야할수도..
            self.fetchDBChats()
            
            //5. 소켓 오픈 해야함~~
            //연결하고, 응답대기
            self.connectSocket()
            self.receiveSocketInfo()
            completion()
            
        }
        
        
        
    }
}

// MARK: fetch 네트워크 통신 관련 메서드
extension ChattingViewModel {
    
    // 우선 이전 DB데이터 TableList에 추가 -> Pagination 고려안함
    // 굳이 completion쓸일 있나? 우선 냅두기 -> 우선 삭제~
    func fetchDBChats() {
        let channelData = ChannelInfoModel(
            workspaceID: channelInfo.workspace_id,
            channel_id: channelInfo.channel_id,
            channel_name: channelInfo.name
        )
        let tableList = chatRepository.fetchAllDBChatting(channelInfo: channelData)
        let data = self.switchTableToInfo(tableList)
        self.chatInfoList = data
    }
    
    func checkLastChatDate() {
        let channelData = ChannelInfoModel(
            workspaceID: channelInfo.workspace_id,
            channel_id: channelInfo.channel_id,
            channel_name: channelInfo.name
        )
        
        self.lastDate = chatRepository.checkChannelChatLastDate(channelInfo: channelData)
        
        print("===채팅 마지막 날짜는 이겁니다 \(self.lastDate)===")
    }
    
    //GET 네트워크 통신 전에 읽은메세지 가장 마지막 채팅 인덱스 확인
    //아예 DB를 fetch해서 index를 찾자
    // 그러니까 순서가 바뀜
    // 1. 마지막 날짜 확인
    // 2. 네트워크 통신 전 저장된 DB 마지막 채팅 인덱스 확인 (DB내의 인덱스가 되는거임) -> 나중에 수정 필요할수도 -> 페이지네이션 할거면 수정해야함
    // 3. GET 네트워크 통신
    // 4. fetch All DB To TableList
    
    func checkDBChatLastIndex() {
        let channelData = ChannelInfoModel(
            workspaceID: channelInfo.workspace_id,
            channel_id: channelInfo.channel_id,
            channel_name: channelInfo.name
        )
        let tableList = chatRepository.fetchAllDBChatting(channelInfo: channelData)
        
        self.scrollIndex = tableList.count - 1
    }
    
    //DB 마지막 날짜 바탕으로 안읽은 메세지 GET 네트워크 통신
    func fetchRecentChatting(completion: @escaping () -> Void) {
        var requestModel: ChattingRequest
        
        if let cursorDate = self.lastDate { // LastDate 있음 -> DB에 채팅 저장된 내역 있음
            requestModel = ChattingRequest(
                workspaceID: self.workspaceID,
                channelName: self.channelInfo.name,
                cursor_date: cursorDate.toString(dateType: .allDate))
        } else { // LastDate 없음 -> 채팅 저장 내역 없음 -> 첨들어옴 -> 들어온 시점을 cursorDate에 넣어서 들어온 순간부터 채팅 보이게 만들기
            requestModel = ChattingRequest(
                workspaceID: self.workspaceID,
                channelName: self.channelInfo.name,
                cursor_date: Date().toString(dateType: .allDate)
            )
        }
        
        APIService.shared.requestCompletion(type: [ChannelChatRes].self, api: ChannelRouter.fetchChatting(requestModel)) { result in
            switch result {
            case .success(let response):
                print("DB 마지막 날짜 바탕으로 안읽은 채팅 내역 불러옴~~")
                print("=====\n\(response)\n=====")
                //여기서 DB에 저장해야함
                //여기까지 읽었습니다 넣을까? 그러면 스크롤도 맨밑이 아니라 여기서 있어야할텐데.. -> Index 네트워크 콜 이전에 저장
                
                self.chatRepository.addChatList(chatInfoList: response, workspaceID: self.workspaceID)
                completion()
                
            case .failure(let error):
                print("===채팅 내역 못불러옴ㅜㅜ===")
                print(error)
            }
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

// MARK: Socket 관련 메서드
extension ChattingViewModel {
    
    func connectSocket() {
        SocketIOManager.shared.establishConnection(channelID: self.channelInfo.channel_id)
    }
    
    func disconnectSocket() {
        SocketIOManager.shared.closeConnection()
    }
    
    func receiveSocketInfo() {
        SocketIOManager.shared.receiveMessage(type: ChannelChatRes.self) { [weak self] response in
            
            guard let self else { return }
            
            print("\n소켓으로 전달받은 채팅 \(response)")
            
            //1. userID 체크해서 내가 보낸거는 걸러주기
            if "\(response.user.user_id)" == KeyChainManager.shared.userID { return }
            
            //Realm에 Socket통신한거 추가
            self.chatRepository.addChat(chatInfo: response, workspaceID: self.workspaceID)
            
            //새로운 데이터로 전달 (추후 테이블리스트에 업데이트 예정)
            let chatInfo = self.switchModelToInfo(response)
            self.newChat.onNext(chatInfo)
            
        }
    }
}

// MARK: TableView 관련 메서드 + SenderView - Images 관련 메서드
extension ChattingViewModel {
    
    func numberOfRowsInSection() -> Int {
        return chatInfoList.count
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> ChattingInfoModel {
        return chatInfoList[indexPath.row]
    }
    
    func clearImages() {
        photoItems.accept([])
    }
}

// MARK: Chatting Model Switching
extension ChattingViewModel {
    
    //DB Table -> ChatInfoModel(TableView재료)
    func switchTableToInfo(_ data: [ChattingTable]) -> [ChattingInfoModel] {
        var infoList: [ChattingInfoModel] = []
        
        data.forEach {
            let info = ChattingInfoModel(
                chat_id: $0.chat_id,
                content: $0.content ?? "",
                createdAt: $0.createdAt,
                files: Array($0.files),
                user_id: $0.sender?.user_id ?? 0,
                nickname: $0.sender?.nickname ?? "",
                profileImage: $0.sender?.profileImage
            )
            
            infoList.append(info)
        }
        
        print("===Table 그려질 InfoModel로 변환했음~ \n\(infoList)\n")
        return infoList
    }
    
    //Network response -> ChatInfoModel (POST때 append)
    func switchModelToInfo(_ data: ChannelChatRes) -> ChattingInfoModel {
        return ChattingInfoModel(
            chat_id: data.chat_id,
            content: data.content ?? "",
            createdAt: data.createdAt.toDate(dateType: .allDate) ?? Date(),
            files: data.files,
            user_id: data.user.user_id,
            nickname: data.user.nickname,
            profileImage: data.user.profileImage
        )
    }
    
}

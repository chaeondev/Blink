//
//  RealmRepository.swift
//  Blink
//
//  Created by Chaewon on 2/6/24.
//

import Foundation
import RealmSwift

protocol RealmRepositoryType {
    
}

class RealmRepository: RealmRepositoryType {
    
    private let realm = try! Realm()
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
}

// MARK: 채널 채팅 CREATE
extension RealmRepository {
    
    // MARK: 채팅 하나 디비 저장(CREATE) -> POST할때
    func addChat(chatInfo: ChannelChatRes, workspaceID: Int) {
        
        //0. 채팅 DB에 존재하는 지 여부 확인 -> 중복 방지 : 서버오류, 소켓오류
        let chats = realm.objects(ChattingTable.self)
        let chatInRealm = chats.where {
            $0.chat_id == chatInfo.chat_id
        }
        if !chatInRealm.isEmpty {
            print("이미 DB에 있는 채팅이니까 채팅 추가할 필요 없음")
            return
        }
        
        //1. 채널 체크 후 없으면 생성 있으면 패스
        let channelInfo = ChannelInfoModel(
            workspaceID: workspaceID,
            channel_id: chatInfo.channel_id,
            channel_name: chatInfo.channelName
        )
        let chatChannel: ChannelTable = self.checkChatChannel(channelInfo)
        print("\n채팅 채널 잘들어갔나 확인 \(chatChannel.channel_id)=====")

        //2. 유저 체크 후 없으면 생성 있으면 패스
        let chatUser: UserTable = self.checkChatUser(chatInfo)
        print("\n채팅 유저 잘들어갔나 확인 \(chatUser)=====")
        
        //3. 채팅 realm 추가 + channel list에 추가 (create 메서드에서 실행)
        let chat = ChattingTable(
            chat_id: chatInfo.chat_id,
            content: chatInfo.content,
            createdAt: chatInfo.createdAt.toDate(dateType: .apiDate)!,
            files: chatInfo.files
        )
        chat.sender = chatUser
        self.createChat(chat, to: chatChannel)

    }
    
    // MARK: 채팅 배열 디비 저장(CREATE) -> GET할때
    func addChatList(chatInfoList: [ChannelChatRes], workspaceID: Int) {
        chatInfoList.forEach { chatInfo in
            self.addChat(chatInfo: chatInfo, workspaceID: workspaceID)
        }
    }
    
    //channel, user Create
    private func createItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("채팅 \(item) Realm 저장 실패")
            print(error)
        }
    }
    
    //chatting Create (channel list append까지)
    private func createChat(_ item: ChattingTable, to channel: ChannelTable) {
        do {
            try realm.write {
                realm.add(item)
                channel.chattings.append(item)
            }
        } catch {
            print("채팅 \(item) Realm 저장 실패")
            print(error)
        }
    }
    
    //채널 realm 존재 여부 파악
    private func checkChatChannel(_ channelInfo: ChannelInfoModel) -> ChannelTable {
        let channels = realm.objects(ChannelTable.self)
        let channelInRealm = channels.where {
            $0.channel_id == channelInfo.channel_id
        }
        if channelInRealm.isEmpty { //realm에 없는 경우 -> create channel
            let newChannel = ChannelTable(
                channel_id: channelInfo.channel_id,
                workspace_id: channelInfo.workspaceID,
                channel_name: channelInfo.channel_name
            )
            self.createItem(newChannel)
            
            return newChannel
            
        } else {
            return channelInRealm.first!
        }
    }
    
    //유저 realm 존재 여부 파악
    private func checkChatUser(_ chatInfo: ChannelChatRes) -> UserTable {
        
        let users = realm.objects(UserTable.self)
        let userInRealm = users.where {
            $0.user_id == chatInfo.user.user_id
        }
        if userInRealm.isEmpty { //realm에 없는 경우 -> create user
            let newUser = UserTable(
                user_id: chatInfo.user.user_id,
                nickname: chatInfo.user.nickname,
                email: chatInfo.user.email,
                profileImage: chatInfo.user.profileImage
            )
            self.createItem(newUser)
            return newUser
        } else {
            return userInRealm.first!
        }
    }
    
}

// MARK: 채널 채팅 정보 가져오기(READ)
extension RealmRepository {
    
    // TODO: 나중에 채팅 많을 때는 전체 가져오기 불가능 -> Pagination 고려 필요 -> 근데 나중에 생각하기
    //DB에서 채널 필터해서 과거 채팅 가져오기
    func fetchAllDBChatting(channelInfo: ChannelInfoModel) -> [ChattingTable] {
        //1. 채널 가져오기
        let chatChannel = self.checkChatChannel(channelInfo)
        //2. 채널 안 채팅 가져오기
        let fetchedChats = chatChannel.chattings.sorted(byKeyPath: "createdAt")
        return Array(fetchedChats)
    }
    
    //Realm에 저장되어있는 마지막 채팅 날짜 가져오기
    func checkChannelChatLastDate(channelInfo: ChannelInfoModel) -> Date? {
        let chatChannel = self.checkChatChannel(channelInfo)
        let lastDate = chatChannel.chattings.sorted(byKeyPath: "createdAt", ascending: false).first?.createdAt
        return lastDate
    }
    
}

// TODO: 채널 정보 업데이트 -> 필요한가..? 변경된 유저라든가 채널정보 바로 업데이트 해주는..?
extension RealmRepository {
    
}

struct ChannelInfoModel {
    let workspaceID: Int
    let channel_id: Int
    let channel_name: String
}

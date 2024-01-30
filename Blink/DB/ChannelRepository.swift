//
//  ChannelRepository.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class ChannelRepository: RepositoryType {
    
    typealias T = ChannelTable

    private let realm = try! Realm()
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
  
    func fetchAll() -> RealmSwift.Results<ChannelTable> {
        
        return realm.objects(ChannelTable.self)
    }
    
    func updateItem(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: ChannelTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}

extension ChannelRepository {
    
    // - 채팅 하나 디비 저장 -> post 할 때
    private func addChat(chatInfo: ChannelChatRes, workspaceID: Int) {
        
        //1. 채널 체크 후 없으면 생성 있으면 패스
        let chatChannel: ChannelTable = self.checkChatChannel(chatInfo, workspaceID)
        print("\n채팅 유저 잘들어갔나 확인 \(chatChannel)=====")

        //2. 유저 체크 후 없으면 생성 있으면 패스
        let chatUser: UserTable = self.checkChatUser(chatInfo)
        print("\n채팅 유저 잘들어갔나 확인 \(chatUser)=====")
        
        //3. 채팅 realm 추가 + channel list에 추가 (create 메서드에서 실행)
        let chat = ChattingTable(
            chat_id: chatInfo.chat_id,
            content: chatInfo.content,
            createdAt: chatInfo.createdAt.toDate(dateType: .allDate)!,
            files: chatInfo.files
        )
        chat.sender = chatUser
        self.createChat(chat, to: chatChannel)

    }
    
    // - 채팅 배열 디비 저장 -> get 할 때
    private func addChatList(chatInfoList: [ChannelChatRes], workspaceID: Int) {
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
                channel.Chattings.append(item)
            }
        } catch {
            print("채팅 \(item) Realm 저장 실패")
            print(error)
        }
    }
    
    //채널 realm 존재 여부 파악
    private func checkChatChannel(_ chatInfo: ChannelChatRes, _ workspaceID: Int) -> ChannelTable {
        let channels = realm.objects(ChannelTable.self)
        let channelInRealm = channels.where {
            $0.channel_id == chatInfo.channel_id
        }
        if channelInRealm.isEmpty { //realm에 없는 경우 -> create channel
            let newChannel = ChannelTable(
                channel_id: chatInfo.channel_id,
                workspace_id: workspaceID,
                channel_name: chatInfo.channelName
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

// TODO: 생성할 때 로직 다시 생각하기
//1. 채팅(채널) 진입 -> 매번 진입할때 마다 로직을 만들어야 하나?
//채팅화면에 들어갈때마다..?그냥 우선 공통적으로 채팅이 생성되는 시점이면 다 판단하기
//(1) 채널이 realm에 있는 지 확인 -> 없으면 추가
//(2) 유저가 realm에 있는 지 확인 -> 없으면 추가
//(3) 채팅 realm에 추가
//(4) 채팅을 채널Realm의 List에 추가

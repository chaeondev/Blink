//
//  DMsChatsRes.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import Foundation

struct DMsChatsRes: Decodable {
    let workspace_id: Int //dm 방이 있는 워크스페이스 아이디
    let room_id: Int //dm 방 아이디
    let chats: [DMChatRes] //채팅 정보
}

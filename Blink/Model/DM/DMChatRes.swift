//
//  DMChatRes.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import Foundation

struct DMChatRes: Decodable {
    let dm_id: Int //dm 채팅 아이디
    let room_id: Int? //dm 채팅방 아이디
    let content: String? // 채팅 내용
    let createdAt: String
    let files: [String]
    let user: User
}

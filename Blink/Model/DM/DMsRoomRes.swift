//
//  DMsRoomRes.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct DMsRoomRes: Decodable {
    let workspace_id: Int
    let room_id: Int //dm 방 아이디
    let createdAt: String
    let user: User //dm 채팅 상대방 정보
}

//
//  DMsUnreadCount.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct DMsUnreadCountRequest: Encodable {
    let roomID: Int
    let workspaceID: Int
    let after: String //특정날짜부터 쌓인 개수 확인가능 공백이면 리턴 0
}

struct DMsUnreadCountResponse: Decodable {
    let room_id: Int
    let count: Int
}

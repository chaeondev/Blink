//
//  ChannelUnreadCount.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct ChannelUnreadCountRequest: Encodable {
    let workspaceID: Int
    let channelName: String
    let after: String //특정 날짜부터 쌓인 채팅의 개수 확인 가능 -> 공백시 count 0 리턴
}

struct ChannelUnreadCountResponse: Decodable {
    let channel_id: Int
    let name: String
    let count: Int //특정 날짜 기준으로 쌓인 채팅 개수
}

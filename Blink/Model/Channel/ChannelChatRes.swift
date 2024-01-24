//
//  ChannelChatRes.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation

struct ChannelChatRes: Decodable {
    let channel_id: Int //채널 아이디
    let channelName: String //채널 명
    let chat_id: Int //채널 채팅 아이디
    let content: String? // 채팅 내용
    let createdAt: String // 채널 채팅 생성 날짜
    let files: [String] //파일들 -> 없으면 빈배열
    let user: User //채팅 보낸 사람의 계정 정보
}

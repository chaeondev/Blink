//
//  Chatting.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation

struct ChattingRequest: Encodable {
    let workspaceID: Int
    let channelName: String
    let cursor_date: String?
}

//실제로 채팅 보여줄때 사용되는 구조체
// Realm DB에서 전달되는 경우가 대부분일듯
struct ChattingInfoModel: Decodable {
    
    let chat_id: Int
    
    let content: String?
    let createdAt: Date
    let files: [String]
    
    let user_id: Int
    let nickname: String
    let profileImage: String?
    
}

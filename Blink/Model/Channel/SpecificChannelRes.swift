//
//  SpecificChannelRes.swift
//  Blink
//
//  Created by Chaewon on 1/25/24.
//

import Foundation

struct SpecificChannelRes: Decodable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
    let `private`: Int //0 공개 1 비공개
    let createdAt: String
    let channelMembers: [ChannelMemberRes]
}

struct ChannelMemberRes: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}

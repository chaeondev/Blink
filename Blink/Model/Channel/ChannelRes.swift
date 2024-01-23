//
//  ChannelRes.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct ChannelRes: Decodable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
    let `private`: Int //채널 비공개 여부 -> 0일 경우 공개, 1일 경우 비공개
    let createdAt: String
}

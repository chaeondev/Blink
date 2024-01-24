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

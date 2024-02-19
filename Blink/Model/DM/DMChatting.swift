//
//  DMChatting.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import Foundation

struct DMChattingRequest: Encodable {
    let userID: Int //상대방 계정
    let workspaceID: Int
    let cursor_date: String?
}

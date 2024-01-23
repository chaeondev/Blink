//
//  WorkspaceRes.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct WorkspaceRes: Decodable {
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    let channels: [ChannelRes]
    let workspaceMembers: [User]
}

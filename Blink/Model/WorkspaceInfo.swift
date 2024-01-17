//
//  WorkspaceInfo.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import Foundation

struct WorkspaceInfoRequest: Encodable {
    let name: String
    let description: String
    let image: Data
}

struct WorkspaceInfoResponse: Decodable {
    let workspace_id: Int //워크스페이스 아이디
    let name: String //워크스페이스 이름
    let description: String? //워크스페이스 설명
    let thumbnail: String //워크스페이스 썸네일 url
    let owner_id: Int //워크스페이스 생성자 계정 유저 아이디
    let createdAt: String //워크스페이스 생성 날짜
}

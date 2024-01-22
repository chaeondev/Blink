//
//  ProfileRes.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct ProfileRes: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String? //소셜로그인 종류
    let sesacCoin: Int
    let createdAt: String
}

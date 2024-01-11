//
//  Login.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let deviceToken: String? //FCM device token
}

struct LoginResponse: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String? //소셜 로그인 종류(이메일 로그인은 null)
    let createdAt: String //$date-time 계정 생성일
    let token: Token
}
// 이메일 SignUpResponse와 동일

//
//  SignUp.swift
//  Blink
//
//  Created by Chaewon on 1/7/24.
//

import Foundation

struct SignUpRequest: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String? // 이후 푸시알림 때 사용
}

struct SignUpResponse: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String? //소셜 로그인 종류(로그인은 null)
    let createdAt: String //$date-time 계정 생성일
    let token: Token
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}

//
//  KakaoLoginRequest.swift
//  Blink
//
//  Created by Chaewon on 2/23/24.
//

import Foundation

struct KakaoLoginRequest: Encodable {
    let oauthToken: String
    let deviceToken: String?
}

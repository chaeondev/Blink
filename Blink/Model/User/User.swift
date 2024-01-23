//
//  User.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation

struct User: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}

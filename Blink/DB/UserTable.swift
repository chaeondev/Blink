//
//  UserTable.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class UserTable: Object {
    @Persisted(primaryKey: true) var user_id: Int
    @Persisted var nickname: String
    @Persisted var email: String
    @Persisted var profileImage: String?
    
    convenience init(user_id: Int, nickname: String, email: String, profileImage: String? = nil) {
        self.init()
        
        self.user_id = user_id
        self.nickname = nickname
        self.email = email
        self.profileImage = profileImage
    }
}

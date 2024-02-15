//
//  UserDefaultsManager.swift
//  Blink
//
//  Created by Chaewon on 2/16/24.
//

import Foundation

enum UserDefaultsManager {
    
    @UserDefaultsWrapper(key: .channelID, defaultValue: -1)
    static var channelID
}

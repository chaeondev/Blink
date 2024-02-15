//
//  UserDefaultsWrapper.swift
//  Blink
//
//  Created by Chaewon on 2/16/24.
//

import Foundation

enum UserDefaultsKey: String {
    case channelID
}

@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: UserDefaultsKey
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}

//
//  KeyChainManager.swift
//  Blink
//
//  Created by Chaewon on 1/7/24.
//

import Foundation
import Security

final class KeyChainManager {
    
    enum accountItem: String {
        case userID = "userID"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    static let shared = KeyChainManager()
    
    var accessToken: String? {
        get {
            return read(account: .accessToken)
        }
    }
    
    var refreshToken: String? {
        get {
            return read(account: .refreshToken)
        }
    }
    
    var userID: String? {
        get {
            return read(account: .userID)
        }
    }
    
    private init() { }
    
    func create(account: accountItem, value: String) {
        
        //query
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account.rawValue,
            kSecValueData : value.data(using: .utf8, allowLossyConversion: false)! //인코딩 과정 손실 허용 여부
        ]
        
        //delete - key값 중복이면 저장 불가능 하니까 우선 delete
        SecItemDelete(keyChainQuery)
        
        //create
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "failed to saving Token")
    }
    
    func read(account: accountItem) -> String? {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account.rawValue,
            kSecReturnData : kCFBooleanTrue as Any, //CFData타입으로 불러옴
            kSecMatchLimit : kSecMatchLimitOne
        ]
        //CFData 타입 -> AnyObject로 받고, Data로 타입변환해서 사용
        
        //read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        //분기처리 (성공, 실패)
        if (status == errSecSuccess) {
            if let retrievedData = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    func delete(account: accountItem) {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account.rawValue
        ]
        
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
    
}

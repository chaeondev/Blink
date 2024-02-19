//
//  DMSRouter.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation
import Alamofire

enum DMSRouter: APIRouter {
    
    case checkDMRooms(_ id: Int) //workspaceID
    case dmsUnreadCount(_ model: DMsUnreadCountRequest)
    case fetchDMChatting(_ model: DMChattingRequest)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkDMRooms(let id):
            return "/v1/workspaces/\(id)/dms"
        case .dmsUnreadCount(let model):
            return "/v1/workspaces/\(model.workspaceID)/dms/\(model.roomID)/unreads"
        case .fetchDMChatting(let model):
            return "/v1/workspaces/\(model.workspaceID)/dms/\(model.userID)/chats"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkDMRooms, .dmsUnreadCount, .fetchDMChatting:
            return .get
        }
    }
    
    var parameter: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    var query: [String : String] {
        switch self {
        case .dmsUnreadCount(let model):
            return ["after": model.after]
        case .fetchDMChatting(let model):
            return ["cursor_date": model.cursor_date ?? ""]
        default:
            return [:]
        }
    }
    
    var multipart: MultipartFormData {
        if self.header["Content-Type"] == "multipart/form-data" {
            return makeMultipartFormData()
        }
        return MultipartFormData()
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        if (method == .post || method == .put) && self.header["Content-Type"] != "multipart/form-data" {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
        }
        
        if method == .get {
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        }
        
        return request
    }
    
    private func makeMultipartFormData() -> MultipartFormData {
        
        guard let parameter = self.parameter else { return MultipartFormData() }
        
        let multiData = MultipartFormData()
        
        for (key, value) in parameter {
            
            // 이미지 데이터
            if let imageData = value as? Data {
                multiData.append(imageData, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
            } else {
                multiData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }
        
        return multiData
    }
    
    
}


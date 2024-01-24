//
//  ChannelRouter.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation
import Alamofire

enum ChannelRouter: APIRouter {
    
    case checkAllChannels(_ id: Int)
    case checkMyChannels(_ id: Int) //workspaceID
    case channelChatUnreadCount(_ model: ChannelUnreadCountRequest)
    case createChannel(_ id: Int, _ model: CreateChannelRequest)
    
    //채팅
    case fetchChatting(_ model: ChattingRequest)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkAllChannels(let id):
            return "/v1/workspaces/\(id)/channels/"
        case .checkMyChannels(let id):
            return "/v1/workspaces/\(id)/channels/my"
        case .channelChatUnreadCount(let model):
            return "/v1/workspaces/\(model.workspaceID)/channels/\(model.channelName)/unreads"
        case .createChannel(let id, _):
            return "/v1/workspaces/\(id)/channels"
            
        //채팅
        case .fetchChatting(let model):
            return "/v1/workspaces/\(model.workspaceID)/channels/\(model.channelName)/chats"
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
        case .checkAllChannels, .checkMyChannels, .channelChatUnreadCount, .fetchChatting:
            return .get
        case .createChannel:
            return .post
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .createChannel(_, let model):
            return [
                "name": model.name,
                "description": model.description
            ]
        default:
            return nil
        }
    }
    
    var query: [String : String] {
        switch self {
        case .channelChatUnreadCount(let model):
            return ["after": model.after]
        case .fetchChatting(let model):
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


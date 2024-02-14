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
    case createChannel(_ id: Int, _ model: CreateChannelRequest)
    case checkChannelInfo(_ id: Int, _ name: String)
    
    //채팅
    case fetchChatting(_ model: ChattingRequest)
    case sendChatting(_ model: SendChattingRequest)
    case channelChatUnreadCount(_ model: ChannelUnreadCountRequest)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkAllChannels(let id):
            return "/v1/workspaces/\(id)/channels/"
        case .checkMyChannels(let id):
            return "/v1/workspaces/\(id)/channels/my"
        case .createChannel(let id, _):
            return "/v1/workspaces/\(id)/channels"
        case .checkChannelInfo(let id, let name):
            return "/v1/workspaces/\(id)/channels/\(name)"
            
        //채팅
        case .fetchChatting(let model):
            return "/v1/workspaces/\(model.workspaceID)/channels/\(model.channelName)/chats"
        case .sendChatting(let model):
            return "/v1/workspaces/\(model.workspaceID)/channels/\(model.channelName)/chats"
        case .channelChatUnreadCount(let model):
            return "/v1/workspaces/\(model.workspaceID)/channels/\(model.channelName)/unreads"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .sendChatting:
            return ["Content-Type": "multipart/form-data",
                    "SesacKey": APIKey.sesacKey]
        default:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkAllChannels, .checkMyChannels, .channelChatUnreadCount, .fetchChatting, .checkChannelInfo:
            return .get
        case .createChannel, .sendChatting:
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
        case .sendChatting(let model):
            return [
                "content": model.content,
                "files": model.files
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
            } else if let imageList = value as? [Data] {
                
                imageList.forEach { image in
                    multiData.append(image, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            } else {
                multiData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }
        
        return multiData
    }
    
    
}


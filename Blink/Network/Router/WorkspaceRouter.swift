//
//  WorkspaceRouter.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import Foundation
import Alamofire

enum WorkspaceRouter: APIRouter {
    
    case getMyWorkspaces
    case createWorkspace(_ model: WorkspaceInfoRequest)
    case checkOneWorkspaceInfo(_ id: Int)
    case leaveWorkspace(_ id: Int)
    case checkWorkspaceMembers(_ id: Int)
    case inviteWorkspace(_ id: Int, _ model: InviteWorkspaceRequest)
    case changeAdmin(_ wsID: Int, _ userID: Int)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyWorkspaces:
            "/v1/workspaces"
        case .createWorkspace:
            "/v1/workspaces"
        case .checkOneWorkspaceInfo(let id):
            "/v1/workspaces/\(id)"
        case .leaveWorkspace(let id):
            "/v1/workspaces/\(id)/leave"
        case .checkWorkspaceMembers(let id):
            "/v1/workspaces/\(id)/members"
        case .inviteWorkspace(let id, _):
            "/v1/workspaces/\(id)/members"
        case .changeAdmin(let id, let userID):
            "/v1/workspaces/\(id)/change/admin/\(userID)"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .createWorkspace:
            return ["Content-Type": "multipart/form-data",
                    "SesacKey": APIKey.sesacKey]
        default:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyWorkspaces, .leaveWorkspace, .checkWorkspaceMembers, .checkOneWorkspaceInfo:
            return .get
        case .createWorkspace, .inviteWorkspace:
            return .post
        case .changeAdmin:
            return .put
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .createWorkspace(let model):
            return [
                "name": model.name,
                "description": model.description,
                "image": model.image
            ]
        case .inviteWorkspace(_, let model):
            return [
                "email": model.email
            ]
        default:
            return [:]
        }
    }
    
    var query: [String : String] {
        switch self {
        default:
            return ["": ""]
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


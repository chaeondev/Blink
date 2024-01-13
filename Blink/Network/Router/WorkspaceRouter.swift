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
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyWorkspaces:
            "/v1/workspaces"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .getMyWorkspaces:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyWorkspaces:
            return .get
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .getMyWorkspaces: return nil
        }
    }
    
    var query: [String : String] {
        switch self {
        case .getMyWorkspaces:
            return ["": ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        if method == .post || method == .put {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
            return request
        }
        
        return request
    }
    
    
}


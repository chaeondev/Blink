//
//  UserRouter.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import Alamofire

enum UserRouter: APIRouter {
    
    case emailValidation
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL+BaseURL.user.rawValue)!
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "validation/email"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .emailValidation:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .emailValidation:
            return .post
        }
    }
    
    var query: [String : String] {
        switch self {
        case .emailValidation:
            return ["": ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        
        return request
    }
    
    
}

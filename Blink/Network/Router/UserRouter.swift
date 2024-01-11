//
//  UserRouter.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import Alamofire

enum UserRouter: APIRouter {
    
    case emailValidation(_ model: EmailValidationRequest)
    case join(_ model: SignUpRequest)
    case login(_ model: LoginRequest)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "/v1/users/validation/email"
        case .join:
            return "/v1/users/join"
        case .login:
            return "/v2/users/login"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .emailValidation, .join, .login:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .emailValidation, .join, .login:
            return .post
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .emailValidation(let model):
            return [
                "email": model.email
            ]
        case .join(let model):
            return [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "phone": model.phone,
                "deviceToken": model.deviceToken
            ]
        case .login(let model):
            return [
                "email": model.email,
                "password": model.password,
                "deviceToken": model.deviceToken
            ]
        }
    }
    
    var query: [String : String] {
        switch self {
        case .emailValidation, .join, .login:
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

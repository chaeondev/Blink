//
//  UserRouter.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import Alamofire

enum UserRouter: APIRouter {
    
    //회원가입, 로그인
    case emailValidation(_ model: EmailValidationRequest)
    case join(_ model: SignUpRequest)
    case login(_ model: LoginRequest)
    
    //토큰 refresh
    case refreshToken
    
    //프로필 조회
    case checkMyProfile
    
    //로그아웃
    case logout
    
    //FCM Device Token 저장
    case saveFcmToken(_ model: FCMDeviceTokenRequest)
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            "/v1/users/validation/email"
        case .join:
            "/v1/users/join"
        case .login:
            "/v2/users/login"
            
        case .refreshToken:
            "/v1/auth/refresh"
            
        case .checkMyProfile:
            "/v1/users/my"
            
        case .logout:
            "/v1/users/logout"
            
        case .saveFcmToken:
            "/v1/users/deviceToken"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .refreshToken:
            return ["SesacKey": APIKey.sesacKey,
                    "Authorization": KeyChainManager.shared.accessToken ?? "",
                    "RefreshToken": KeyChainManager.shared.refreshToken ?? ""]
        default:
            return ["Content-Type": "application/json",
                    "SesacKey": APIKey.sesacKey]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .emailValidation, .join, .login, .saveFcmToken:
            return .post
        case .refreshToken, .checkMyProfile, .logout:
            return .get
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
        case .saveFcmToken(let model):
            return [
                "deviceToken": model.deviceToken
            ]
        default:
            return [:]
        }
    }
    
    var query: [String : String] {
        switch self {
        default:
            return [:]
        }
    }
    
    var multipart: MultipartFormData {
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
            return request
        }
        
        if method == .get {
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        }
        
        return request
    }
    
    
}

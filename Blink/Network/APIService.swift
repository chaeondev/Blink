//
//  APIService.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkResult<T: Decodable> {
    case success(T)
    case failure(ErrorResponse)
}

final class APIService {
    
    static let shared = APIService()
    
    private init() { }
    
    
    // MARK: Single
    func request<T: Decodable, U: APIRouter>(type: T.Type, api: U) -> Single<NetworkResult<T>> {
        
        return Single<NetworkResult<T>>.create { single in
            
            AF.request(api, interceptor: AuthInterceptor()).validate().responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    print("===Single+Interceptor Network 통신 성공===")
                    return single(.success(.success(data)))
                case .failure(_):
                    print("===Single+Interceptor Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                    
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    
                    errorResponse = self.decodingError(from: data)
                    
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
            
        }
        
    }
    
    // MARK: Single + interceptor 포함 X 버전
    func requestNoInterceptor<T: Decodable, U: APIRouter>(type: T.Type, api: U) -> Single<NetworkResult<T>> {
        
        return Single<NetworkResult<T>>.create { single in
            
            AF.request(api).validate().responseDecodable(of: T.self) { response in
            
                switch response.result {
                case .success(let data):
                    print("===Single+NoInterceptor Network 통신 성공===")
                    return single(.success(.success(data)))
                case .failure(_):
                    print("===Single+NoInterceptor Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                    
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    
                    errorResponse = self.decodingError(from: data)
                    
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }

            
            return Disposables.create()
            
        }
        
    }
    
    // MARK: Single+Empty Data -> Status code로 구분
    func requestEmptyReesponse<U: APIRouter>(api: U) -> Single<NetworkResult<String>> {
    
        return Single<NetworkResult<String>>.create { single in
            
            AF.request(api).validate().response { response in
                
                print("==debug==", response.debugDescription)
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    print("===Single+EmptyData Network 통신 성공===")
                    return single(.success(.success("Success")))
                    
                } else {
                    print("===Single+EmptyData Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                    
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    
                    errorResponse = self.decodingError(from: data)
                    
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: Single + Multipart
    func requestMultipart<T: Decodable, U: APIRouter>(type: T.Type, api: U) -> Single<NetworkResult<T>> {
        
        return Single<NetworkResult<T>>.create { single in
            
            AF.upload(multipartFormData: api.multipart, with: api, interceptor: AuthInterceptor())
                .validate()
                .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    print("===Single+Multipart - Network 통신 성공===")
                    return single(.success(.success(data)))
                case .failure(_):
                    print("===Single+Multipart - Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                    
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    
                    errorResponse = self.decodingError(from: data)
                    
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
            
        }
        
    }
    
    // MARK: Completion+Interceptor
    func requestCompletion<T: Decodable, U: APIRouter>(type: T.Type, api: U, completion: @escaping (NetworkResult<T>) -> Void) {
        AF.request(api, interceptor: AuthInterceptor()).validate().responseDecodable(of: T.self) { response in
        
            switch response.result {
            case .success(let data):
                print("===Completion+Interceptor Network 통신 성공===")
                completion(.success(data))
            case .failure(_):
                print("===Completion+Interceptor Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                
                var errorResponse = ErrorResponse(errorCode: "server error")
                
                guard let data = response.data else { return }
                
                errorResponse = self.decodingError(from: data)
                
                print("===error code===", errorResponse)
                completion(.failure(errorResponse))
            }
        }
    }
    
    // MARK: Completion + Multipart
    func requestMultipartCompletion<T: Decodable, U: APIRouter>(type: T.Type, api: U, completion: @escaping (NetworkResult<T>) -> Void) {
        
        AF.upload(multipartFormData: api.multipart, with: api, interceptor: AuthInterceptor())
            .validate()
            .responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let data):
                print("===Completion+Multipart - Network 통신 성공===")
                completion(.success(data))
            case .failure(_):
                print("===Completion+Multipart - Network 통신 실패=== \(String(describing: response.response?.statusCode))")
                
                var errorResponse = ErrorResponse(errorCode: "server error")
                
                guard let data = response.data else { return }
                
                errorResponse = self.decodingError(from: data)
                
                print("===error code===", errorResponse)
                completion(.failure(errorResponse))
            }
        }
        
    }
    
    private func decodingError(from jsonData: Data) -> ErrorResponse {
        do {
            let serverError = try JSONDecoder().decode(ErrorResponse.self, from: jsonData)
            
            return serverError
        }
        catch {
            print(error)
            
            return ErrorResponse(errorCode: "server error")
        }
    }
    
    
    
}

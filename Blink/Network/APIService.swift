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
    
    func request<T: Decodable, U: APIRouter>(type: T.Type, api: U) -> Single<NetworkResult<T>> {
        
        return Single<NetworkResult<T>>.create { single in
            
            AF.request(api).validate().responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    print("===Network 통신 성공===")
                    return single(.success(.success(data)))
                case .failure(let error):
                    print("===Network 통신 실패=== \(response.response?.statusCode)")
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    do {
                        let serverError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        errorResponse = serverError
                    }
                    catch {
                        print(error)
                    }
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
            
        }
        
    }
    
    func requestEmptyReesponse<U: APIRouter>(api: U) -> Single<NetworkResult<String>> {
    
        return Single<NetworkResult<String>>.create { single in
            
            AF.request(api).validate().response { response in
                
                print("==debug==", response.debugDescription)
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    print("===Network 통신 성공===")
                    return single(.success(.success("Success")))
                    
                } else {
                    print("===Network 통신 실패=== \(response.response?.statusCode)")
                    
                    var errorResponse = ErrorResponse(errorCode: "server error")
                    
                    guard let data = response.data else { return single(.success(.failure(errorResponse))) }
                    do {
                        let serverError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        errorResponse = serverError
                    }
                    catch {
                        print(error)
                    }
                    print("===error code===", errorResponse)
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    
    
    
}

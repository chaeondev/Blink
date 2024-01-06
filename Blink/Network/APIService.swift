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
    
    func request<T: Decodable>(type: T.Type, api: APIRouter) -> Single<NetworkResult<T>> {
        
        return Single<NetworkResult<T>>.create { single in
            
            AF.request(api).validate().responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    return single(.success(.success(data)))
                case .failure(let error):
                    let errorResponse = ErrorResponse(errorCode: "")
                    return single(.success(.failure(errorResponse)))
                }
            }
            return Disposables.create()
            
        }
        
    }
    
    
    
    
    
    
}

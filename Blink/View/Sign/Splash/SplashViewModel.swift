//
//  SplashViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let autoLoginValidation: PublishSubject<Bool>
        let workspaceListResult: PublishSubject<WorkspaceListResult>
    }
    
    func transform(input: Input) -> Output {
        
        let autoLoginValidation = PublishSubject<Bool>()
        let workspaceListResult = PublishSubject<WorkspaceListResult>()
        
        if let _ = KeyChainManager.shared.accessToken,
           let _ = KeyChainManager.shared.refreshToken {
            
            APIService.shared.requestNoInterceptor(type: RefreshResponse.self, api: UserRouter.refreshToken)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let response):
                        KeyChainManager.shared.create(account: .accessToken, value: response.accessToken)
                        autoLoginValidation.onNext(true)
                    case .failure(let error):
                        
                        let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                        let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : RefreshTokenError(rawValue: error.errorCode)
                        
                        if customError as? RefreshTokenError == .serverConflict {
                            autoLoginValidation.onNext(true)
                        } else {
                            autoLoginValidation.onNext(false)
                            KeyChainManager.shared.delete(account: .accessToken)
                            KeyChainManager.shared.delete(account: .refreshToken)
                            KeyChainManager.shared.delete(account: .userID)
                        }
                        
                        print("===autoLogin Error===", customError as Any)
                    }
                }
                .disposed(by: disposeBag)
        } else {
            autoLoginValidation.onNext(false)
        }
        
        autoLoginValidation
            .filter { $0 }
            .flatMapLatest { _ in
                APIService.shared.request(type: [WorkspaceInfoResponse].self, api: WorkspaceRouter.getMyWorkspaces)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("내 워크스페이스 조회 성공")
                    if let wsID = response.first?.workspace_id {
                        workspaceListResult.onNext(.notEmpty(id: wsID))
                    } else {
                        workspaceListResult.onNext(.empty)
                    }
                case .failure(let error):
                    print("내 워크스페이스 조회 실패")
                    print("===에러 \(error)===")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(autoLoginValidation: autoLoginValidation, workspaceListResult: workspaceListResult)
    }
}

enum WorkspaceListResult {
    case empty
    case notEmpty(id: Int)
}


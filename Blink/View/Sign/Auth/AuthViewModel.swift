//
//  AuthViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/23/24.
//

import Foundation
import RxSwift
import RxCocoa

import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

final class AuthViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let kakaoLoginButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let kakaoLoginResult: PublishSubject<LoginNetworkResult<LoginResponse>>
        let workspaceInfo: PublishSubject<WorkspaceType>
    }
    
    func transform(input: Input) -> Output {
        
        let kakaoLoginResult = PublishSubject<LoginNetworkResult<LoginResponse>>()
        let workspaceInfo = PublishSubject<WorkspaceType>()
        
        input.kakaoLoginButtonTapped
            .flatMapLatest {
                self.kakaoLogin()
            }
            .flatMapLatest {
                switch $0 {
                case .success(let oauthToken):
                    let requestModel = KakaoLoginRequest(oauthToken: oauthToken.accessToken, deviceToken: UserDefaultsManager.fcmDeviceToken)
                    return APIService.shared.request(type: LoginResponse.self, api: UserRouter.kakaoLogin(requestModel))
                case .failure(let error):
                    print("카카오 로그인 불가능!!!")
                    print(error)
                    return Single<NetworkResult<LoginResponse>>.create { single in
                        Disposables.create()
                    }
                }
            }
            .filter {
                switch $0 {
                case .success(let response):
                    KeyChainManager.shared.create(account: .userID, value: "\(response.user_id)")
                    KeyChainManager.shared.create(account: .accessToken, value: response.token.accessToken)
                    KeyChainManager.shared.create(account: .refreshToken, value: response.token.refreshToken)
                    // TODO: UserDefaults -> Login True
                    kakaoLoginResult.onNext(.success(response))
                    return true
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : SignUpError(rawValue: error.errorCode)
                    
                    if customError as? LoginError == .loginFailed {
                        kakaoLoginResult.onNext(.loginFailed)
                    } else {
                        kakaoLoginResult.onNext(.networkError)
                    }
                    
                    print("==Login Network Failed \(String(describing: customError))==")
                    return false
                }
            }
        
            // MARK: 로그인 후에 워크스페이스 empty인지 아닌지 체크 필요함
        
            .flatMapLatest { _ in
                APIService.shared.request(type: [WorkspaceInfoResponse].self, api: WorkspaceRouter.getMyWorkspaces)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===GETMYWORKSPACE SUCCESS=== \(response)")

                    if response.isEmpty {
                        workspaceInfo.onNext(.empty)
                    } else {
                        workspaceInfo.onNext(.notEmpty(wsID: response[0].workspace_id))
                    }
                case .failure(let error):
                    let customError = NetworkError(rawValue: error.errorCode)
                    print("===워크스페이스 불러오기 네트워크 실패=== \(String(describing: customError))")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(kakaoLoginResult: kakaoLoginResult, workspaceInfo: workspaceInfo)
    }
}

extension AuthViewModel {
    
    func kakaoLogin() -> Single<Result<OAuthToken, Error>> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("카톡 가능하다~~")
            
            return Single.create { single in
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(with: self) { owner, oauthToken in
                        return single(.success(.success(oauthToken)))
                    } onError: { owner, error in
                        return single(.success(.failure(error)))
                    }
            }
        } else {
            print("카톡 앱 없따~~")
            
            return Single.create { single in
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(with: self) { owner, oauthToken in
                        return single(.success(.success(oauthToken)))
                    } onError: { owner, error in
                        return single(.success(.failure(error)))
                    }

            }
        }
    }
}


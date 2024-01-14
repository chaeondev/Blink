//
//  LoginViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    enum LoginValidation {
        case invalidEmail
        case invalidPassword
    }
    
    enum LoginNetworkResult<T: Decodable> {
        case networkError
        case loginFailed
        case success(T)
    }
    
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
    private let pwRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let loginButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validationOutput: BehaviorSubject<[LoginValidation]>
        let networkResult: PublishSubject<LoginNetworkResult<LoginResponse>>
    }
    
    func transform(input: Input) -> Output {
        let isValidEmail = BehaviorSubject(value: false)
        let isValidPassword = BehaviorSubject(value: false)
        
        let validationOutput: BehaviorSubject<[LoginValidation]> = BehaviorSubject(value: [])
        let networkResult = PublishSubject<LoginNetworkResult<LoginResponse>>()
        
        // MARK: 이메일 유효성 검증
        input.emailText
            .asObservable()
            .map { $0.range(of: self.emailRegEx, options: .regularExpression) != nil }
            .bind(to: isValidEmail)
            .disposed(by: disposeBag)
        
        // MARK: 비밀번호 조건 검증
        input.pwText
            .asObservable()
            .map { $0.range(of: self.pwRegEx, options: .regularExpression) != nil }
            .bind(to: isValidPassword)
            .disposed(by: disposeBag)
        
        // MARK: 로그인 버튼 클릭
        
        //loginRequest 구조체 만들기
        let loginRequest = Observable.combineLatest(
            input.emailText,
            input.pwText
        )
            .map { (email, password) in
                return LoginRequest(
                    email: email,
                    password: password,
                    deviceToken: nil // TODO: 나중에 변경
                    )
            }
        
        let validation = Observable.combineLatest(
            isValidEmail,
            isValidPassword
        )
        
        //login 버튼 클릭 > validation 검증 > 네트워크 통신
        input.loginButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(validation) { _, validation in
                var list: [LoginValidation] = []
                if !validation.0 {
                    list.append(.invalidEmail)
                }
                if !validation.1 {
                    list.append(.invalidPassword)
                }
                validationOutput.onNext(list)
                return validation.0 && validation.1
            }
            .filter { $0 }
            .withLatestFrom(loginRequest)
            .flatMapLatest {
                APIService.shared.request(type: LoginResponse.self, api: UserRouter.login($0))
            }
            .filter {
                switch $0 {
                case .success(let response):
                    KeyChainManager.shared.create(account: .userID, value: "\(response.user_id)")
                    KeyChainManager.shared.create(account: .accessToken, value: response.token.accessToken)
                    KeyChainManager.shared.create(account: .refreshToken, value: response.token.refreshToken)
                    // TODO: UserDefaults -> Login True
                    networkResult.onNext(.success(response))
                    return true
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : SignUpError(rawValue: error.errorCode)
                    
                    if customError as? LoginError == .loginFailed {
                        networkResult.onNext(.loginFailed)
                    } else {
                        networkResult.onNext(.networkError)
                    }
                    
                    print("==Login Network Failed \(customError)==")
                    return false
                }
            }
            .flatMapLatest { _ in
                APIService.shared.request(type: [WorkspaceInfoResponse].self, api: WorkspaceRouter.getMyWorkspaces)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===GETMYWORKSPACE SUCCESS=== \(response)")
                    // TODO: 워크스페이스 홈화면 전환
                case .failure(let error):
                    let customError = NetworkError(rawValue: error.errorCode)
                    print("===워크스페이스 불러오기 네트워크 실패=== \(customError)")
                }
            }
            .disposed(by: disposeBag)

        return Output(validationOutput: validationOutput, networkResult: networkResult)
    }
}

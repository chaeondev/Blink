//
//  SignUpViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {

    enum EmailValid {
        case invalid
        case duplicated
        case networkError
        case available
    }
    
    enum JoinValidation {
        case notVerifiedEmail
        case invalidNickname
        case invalidPhoneNum
        case invalidPassword
        case notSamePassword
    }
    
    enum JoinNetworkResult<T: Decodable> {
        case alreadyJoined
        case networkError
        case success(T)
    }
    
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
    private let phoneRegEx = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
    private let pwRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let nickText: ControlProperty<String>
        let phoneText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let repwText: ControlProperty<String>
        let checkEmailButtonTap: ControlEvent<Void>
        let joinButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailValidation: BehaviorSubject<EmailValid>
        let phoneNum: BehaviorSubject<String>
        let validationOutput: BehaviorSubject<[JoinValidation]>
        let networkResult: PublishSubject<JoinNetworkResult<SignUpResponse>>
    }
    
    func transform(input: Input) -> Output {
        
        let isValidEmail: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let isVerifiedEmail: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let emailValidation = BehaviorSubject<EmailValid>(value: .networkError)
        
        let isValidNickname = BehaviorSubject(value: false)
        
        let phoneNum: BehaviorSubject<String> = BehaviorSubject(value: "")
        let isValidPhone = BehaviorSubject(value: false)
        
        let isValidPW = BehaviorSubject(value: false)
        let isSamePW = BehaviorSubject(value: false)

        let validationOutput: BehaviorSubject<[JoinValidation]> = BehaviorSubject(value: [])
        let networkResult = PublishSubject<JoinNetworkResult<SignUpResponse>>()
        
        // MARK: 이메일
        
        //이메일 정규식 검증
        input.emailText
            .asObservable()
            .map { $0.range(of: self.emailRegEx, options: .regularExpression) != nil }
            .subscribe(with: self) { owner, bool in
                isValidEmail.onNext(bool)
            }
            .disposed(by: disposeBag)
        
        //이메일 검증 여부 -> text 변하면 false 처리
        input.emailText
            .asObservable()
            .bind(with: self) { owner, text in
                isVerifiedEmail.onNext(false)
            }
            .disposed(by: disposeBag)
        
        //이메일 중복 확인 버튼
        input.checkEmailButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(isValidEmail) { _, isValid in
                if !isValid {
                    emailValidation.onNext(.invalid)
                }
                return isValid
            }
            .filter { $0 }
            .withLatestFrom(isVerifiedEmail) { isValid, isVerified in
                if isVerified {
                    emailValidation.onNext(.available)
                }
                return isVerified
            }
            .filter { !$0 }
            .withLatestFrom(input.emailText) { isVerified, text in
                return text
            }
            .map {
                print("==email text==", $0)
                return EmailValidationRequest(email: $0)
            }
            .flatMapLatest {
                APIService.shared.requestEmptyReesponse(api: UserRouter.emailValidation($0))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success:
                    isVerifiedEmail.onNext(true)
                    emailValidation.onNext(.available)
                    print("EmailValidation Success")
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : EmailValidationError(rawValue: error.errorCode)
                
                    if customError as? EmailValidationError == .serverConflict {
                        emailValidation.onNext(.duplicated)
                    } else {
                        emailValidation.onNext(.networkError)
                    }

                    
                    print("EmailValidation Failed \(customError)")
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 닉네임
        input.nickText
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(to: isValidNickname)
            .disposed(by: disposeBag)
        
        // MARK: 전화번호
        input.phoneText
            .asObservable()
            .bind(with: self) { owner, text in
                var result = ""
                if text.count >= 13 {
                    result = text.formated(by: "###-####-####")
                } else {
                    result = text.formated(by: "###-###-####")
                }
                
                phoneNum.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.phoneText
            .asObservable()
            .map { $0.range(of: self.phoneRegEx, options: .regularExpression) != nil || $0.isEmpty }
            .bind(to: isValidPhone)
            .disposed(by: disposeBag)
        
        // MARK: 비밀번호
        
        //비밀번호 정규식 검증
        input.pwText
            .asObservable()
            .map { $0.range(of: self.pwRegEx, options: .regularExpression) != nil }
            .bind(to: isValidPW)
            .disposed(by: disposeBag)
        
        //비밀번호 확인
        Observable.combineLatest(input.pwText, input.repwText)
            .filter { component in
                !component.0.isEmpty
            }
            .map { $0 == $1 }
            .bind(to: isSamePW)
            .disposed(by: disposeBag)
        
        // MARK: 가입하기 버튼
        
        //signUpRequest 구조체 만들기
        let signUpRequest = Observable.combineLatest(
            input.emailText,
            input.pwText,
            input.nickText,
            input.phoneText
        )
            .map { (email, password, nickname, phone) in
                return SignUpRequest(
                    email: email,
                    password: password,
                    nickname: nickname,
                    phone: phone.isEmpty ? nil : phone,
                    deviceToken: nil // TODO: 나중에 변경
                )
            }
        
        //전체 validation 검증
        let isCheckedEmail = emailValidation.map { $0 == .available }
        
        let validation = Observable.combineLatest(
            isCheckedEmail,
            isValidNickname,
            isValidPhone,
            isValidPW,
            isSamePW
        )

        //가입하기 버튼 클릭 > 전체 validation 검증 > 네트워크 통신
        input.joinButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(validation) { _, validation in
                var list: [JoinValidation] = []
                if !validation.0 {
                    print("notVerifiedEmail")
                    list.append(.notVerifiedEmail)
                }
                if !validation.1 {
                    list.append(.invalidNickname)
                }
                if !validation.2 {
                    print("invalidPhoneNum")
                    list.append(.invalidPhoneNum)
                }
                if !validation.3 {
                    list.append(.invalidPassword)
                }
                if !validation.4 {
                    list.append(.notSamePassword)
                }
                validationOutput.onNext(list)
                return validation.0 && validation.1 && validation.2 && validation.3 && validation.4
            }
            .filter { $0 }
            .withLatestFrom(signUpRequest)
            .flatMapLatest {
                APIService.shared.request(type: SignUpResponse.self, api: UserRouter.join($0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    networkResult.onNext(.success(response))
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : SignUpError(rawValue: error.errorCode)
                
                    if customError as? SignUpError == .serverConflict {
                        networkResult.onNext(.alreadyJoined)
                    } else {
                        networkResult.onNext(.networkError)
                    }

                    print("SignUp Network Failed \(customError)")
                }
            }
            .disposed(by: disposeBag)
        
        

        return Output(emailValidation: emailValidation,phoneNum: phoneNum, validationOutput: validationOutput, networkResult: networkResult)
    }

}

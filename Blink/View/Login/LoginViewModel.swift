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
    
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
    private let pwRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let loginButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let isValidEmail = BehaviorSubject(value: false)
        let isValidPassword = BehaviorSubject(value: false)
        
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
        
        
        
        
        
        return Output()
    }
}

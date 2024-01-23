//
//  InviteMemberViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation
import RxSwift
import RxCocoa

enum InviteResult {
    case success
    case serverConflict
    case noData
    case invalidEmail
    case permissionDenied
    case networkError
}

final class InviteMemberViewModel: ViewModelType {
    
    var workspaceId: Int = 0
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let sendButtonTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
    }
    
    struct Output {
        let inviteResult: PublishSubject<InviteResult>
    }
    
    func transform(input: Input) -> Output {
        
        let inviteResult = PublishSubject<InviteResult>()
        
        input.sendButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText)
            .map {
                return InviteWorkspaceRequest(email: $0)
            }
            .flatMapLatest {
                APIService.shared.request(type: User.self, api: WorkspaceRouter.inviteWorkspace(self.workspaceId, $0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===워크스페이스 멤버 초대 성공=== \(response.email)")
                    inviteResult.onNext(.success)
                case .failure(let error):
                    print("===워크스페이스 멤버 초대 실패===")
                    
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : InviteWorkspaceError(rawValue: error.errorCode)
                    
                    if let wsError = customError as? InviteWorkspaceError {
                        switch wsError {
                        case .noData:
                            inviteResult.onNext(.noData)
                        case .unknownUser:
                            inviteResult.onNext(.networkError)
                        case .permissionDenied:
                            inviteResult.onNext(.permissionDenied)
                        case .wrongRequest:
                            inviteResult.onNext(.invalidEmail)
                        case .serverConflict:
                            inviteResult.onNext(.serverConflict)
                        }
                    }
                    
                    print("===Invite Member Failed \(String(describing: customError))===")
                    
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(inviteResult: inviteResult)
    }
}

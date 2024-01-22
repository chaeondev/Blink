//
//  HomeDefaultViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeDefaultViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let wsID: Int
    }
    
    struct Output {
        let workspaceResource: PublishSubject<WorkspaceRes>
        let profileResource: PublishSubject<ProfileRes>
    }
    
    func transform(input: Input) -> Output {
        
        let workspaceResource = PublishSubject<WorkspaceRes>()
        let profileResource = PublishSubject<ProfileRes>()
        
        APIService.shared.request(type: WorkspaceRes.self, api: WorkspaceRouter.checkOneWorkspaceInfo(input.wsID))
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===워크스페이스 한개 정보 조회 성공===")
                    workspaceResource.onNext(response)
                case .failure(let error):
                    print("===워크스페이스 한개 정보 조회 실패===")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        APIService.shared.request(type: ProfileRes.self, api: UserRouter.checkMyProfile)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===프로필 조회 성공===")
                    profileResource.onNext(response)
                case .failure(let error):
                    print("===프로필 조회 실패===")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(workspaceResource: workspaceResource, profileResource: profileResource)
    }
}

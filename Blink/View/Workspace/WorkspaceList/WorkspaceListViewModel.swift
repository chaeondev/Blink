//
//  WorkspaceListViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/18/24.
//

import Foundation
import RxSwift
import RxCocoa

enum LeaveWorkspaceResult {
    case success(isEmpty: Bool, homeWSID: Int?)
    case noData
    case reject
    case networkError
}

final class WorkspaceListViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    
    var selectedWorkspaceID: Int? //nil이면 워크스페이스 empty
    
    //워크스페이스 퇴장 네트워크(completion)결과 받는애
    let leaveNetworkResult = PublishSubject<LeaveWorkspaceResult>()
    
    struct Input {
        let loadData: PublishSubject<Void>
    }
    
    struct Output {
        let items: PublishSubject<[WorkspaceInfoResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = PublishSubject<[WorkspaceInfoResponse]>()
        
        //1. HomeDefault에서 넘어왔을때
        if selectedWorkspaceID != nil {
            
            //우선 items 네트워크 통신부터 해야함
            input.loadData
                .flatMapLatest {
                    APIService.shared.request(type: [WorkspaceInfoResponse].self, api: WorkspaceRouter.getMyWorkspaces)
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let response):
                        print("===워크스페이스 리스트 네트워크 성공===")
                        items.onNext(response)
                        
                    case .failure(let error):
                        let customError = NetworkError(rawValue: error.errorCode)
                        print("===워크스페이스 리스트 네트워크 실패=== \(String(describing: customError))")
                    }
                }
                .disposed(by: disposeBag)
            
            
        }
        
        //2. HomeEmpty에서 넘어왔을때
        else {
            
        }
        
        return Output(items: items)
    }
}

extension WorkspaceListViewModel {
    
    func checkSelectedWS(_ data: WorkspaceInfoResponse) -> Bool {
        return data.workspace_id == self.selectedWorkspaceID
    }
    
    //워크스페이스 나가기 로직
    func leaveWorkspace(_ id: Int) {
        
        APIService.shared.requestCompletion(type: [WorkspaceInfoResponse].self, api: WorkspaceRouter.leaveWorkspace(id)) { [weak self] result in
            switch result {
            case .success(let response):
                print("===워크스페이스 퇴장 네트워크 성공===")
                if response.isEmpty {
                    print("워크스페이스 이제없음~~ -> Home Empty")
                    self?.leaveNetworkResult.onNext(.success(isEmpty: true, homeWSID: nil))
                } else {
                    print("워크스페이스 남아있음~~가장 최근날짜 생성된 워크스페이스로!")
                    let newWorkspaceID = response.first!.workspace_id
                    self?.leaveNetworkResult.onNext(.success(isEmpty: false, homeWSID: newWorkspaceID))
                }
                
            case .failure(let error):
                print("===워크스페이스 퇴장 네트워크 실패===")
                let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : LeaveWorkspaceError(rawValue: error.errorCode)
                
                if let wsError = customError as? LeaveWorkspaceError {
                    switch wsError {
                    case .noData:
                        print("===워크스페이스 데이터가 없어서 퇴장 불가능!!===")
                        self?.leaveNetworkResult.onNext(.noData)
                    case .rejectRequest:
                        print("===너 관리자임??(워크스페이스, 채널 관리자 여부 확인)===")
                        self?.leaveNetworkResult.onNext(.reject)
                    }
                } else {
                    self?.leaveNetworkResult.onNext(.networkError)
                }
                
                print("==Leave Workspace Failed \(String(describing: customError))")
            }
        }
    }
}

//
//  WorkspaceListViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkspaceListViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    
    var selectedWorkspaceID: Int? //nil이면 워크스페이스 empty
    
    struct Input {
        let loadData: PublishSubject<Void>
    }
    
    struct Output {
        let items: PublishSubject<[WorkspaceInfoResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = PublishSubject<[WorkspaceInfoResponse]>()
        
        print("===selectedWorkspaceID : \(selectedWorkspaceID)")
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
}

//
//  ChangeAdminViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeAdminViewModel {
    
    var workspaceID: Int!
    var items: [User] = []
    
    func fetchMembers(completion: @escaping (Bool) -> Void) {
        APIService.shared.requestCompletion(type: [User].self, api: WorkspaceRouter.checkWorkspaceMembers(workspaceID)) { result in
            switch result {
            case .success(let response):
                
                self.items = response.filter {
                    "\($0.user_id)" != KeyChainManager.shared.userID
                }
                
                completion(self.items.isEmpty)
                
            case .failure(let error):
                print("===워크스페이스 멤버조회 에러===", error)
            }
        }
    }
   
}

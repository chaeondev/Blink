//
//  MyProfileViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModelType {
    
    var profileData = ProfileData(
        first: [
            ProfileCellInfo(title: "내 새싹 코인 130", isAttributedString: true, detail: "충전하기", accessory: .disclosure),
            ProfileCellInfo(title: "닉네임", detail: "옹골찬 고래밥", accessory: .disclosure),
            ProfileCellInfo(title: "연락처", detail: "010-1234-1234", accessory: .disclosure)
        ],
        second: [
            ProfileCellInfo(title: "이메일", detail: "blink@blink.com", accessory: .none),
            ProfileCellInfo(title: "연결된 소셜 계정", accessory: .custom([.apple, .kakao])),
            ProfileCellInfo(title: "로그아웃", accessory: .none)
        ]
    )
    
    var profileImageStr = BehaviorSubject(value: "")
    
    struct Input {
        
    }
    
    struct Output {
        let profileImageStr: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(profileImageStr: self.profileImageStr)
    }
}

extension MyProfileViewModel {
    
    func fetchProfileData(completion: @escaping () -> Void) {
        APIService.shared.requestCompletion(type: ProfileRes.self, api: UserRouter.checkMyProfile) { [weak self] result in
            switch result {
            case .success(let response):
                print("=======내 프로필 조회 성공========")
                
                //TableView
                //1. 새싹코인
                self?.profileData.first[0].title = "내 새싹 코인 \(response.sesacCoin)"
                //2. 닉네임
                self?.profileData.first[1].detail = response.nickname
                //3. 연락처
                self?.profileData.first[2].detail = response.phone ?? ""
                //4. 이메일
                self?.profileData.second[0].detail = response.email
                //5. 소셜
                // TODO: 나중에 업데이트 하기
                
                //프로필 이미지
                self?.profileImageStr.onNext(response.profileImage ?? "")
                
                completion()
                
            case .failure(let error):
                print("=======내 프로필 조회 실패=======")
                print(error)
                
            }
        }
    }
    
    func profileDataForCell(_ indexPath: IndexPath) -> ProfileCellInfo {
        switch indexPath.section {
        case 0:
            return profileData.first[indexPath.row]
        case 1:
            return profileData.second[indexPath.row]
        default:
            return ProfileCellInfo(title: "오류오류", accessory: .none)
        }
    }
}

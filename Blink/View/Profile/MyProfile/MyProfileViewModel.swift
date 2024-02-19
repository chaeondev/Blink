//
//  MyProfileViewModel.swift
//  Blink
//
//  Created by Chaewon on 2/19/24.
//

import Foundation

final class MyProfileViewModel: ViewModelType {
    
    let profileData = ProfileData(
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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension MyProfileViewModel {
    
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

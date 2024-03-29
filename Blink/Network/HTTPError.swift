//
//  HTTPError.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation

protocol HTTPError: CaseIterable, Error {
    var rawValue: String { get }
}

//공통 에러
enum NetworkError: String, HTTPError {
    //400
    case forbidden = "E01" //접근권한
    case invalidRoute = "E97" //알수없는 라우터 경로
    case accessTokenExpired = "E05" //액세스 토큰 만료
    case accountNotFound = "E03" //알수없는 계정 (계정 정보 조회 실패)
    case overcall = "E98" //과호출
    //500
    case serverError = "E99" //내부 서버 오류
}

// MARK: =======USER=======

//이메일 유효성 검증
enum EmailValidationError: String, HTTPError {
    case serverConflict = "E12" //중복 데이터
    case wrongRequest = "E11" //잘못된 요청
}

//회원가입
enum SignUpError: String, HTTPError {
    case serverConflict = "E12" //중복 데이터
    case wrongRequest = "E11" //잘못된 요청
}

//로그인
enum LoginError: String, HTTPError {
    case loginFailed = "E03" //로그인 실패
}

//토큰 리프레시
enum RefreshTokenError: String, HTTPError {
    case serverConflict = "E04" //유효한 토큰
    case unknownUser = "E03" //알수없는 계정
    case refreshTokenExpired = "E06" //리프레시 토큰 만료
    case authFailed = "E02" //인증실패
}

// MARK: =======WORKSPACE=======

//워크스페이스 생성
enum CreateWorkspaceError: String, HTTPError {
    case wrongRequest = "E11" //잘못된 요청
    case serverConflict = "E12" //중복 데이터 -> 워크스페이스 명은 고유한 데이터
    case insufficientCoin = "E21" //새싹코인 부족
}

//워크스페이스 퇴장
enum LeaveWorkspaceError: String, HTTPError {
    case noData = "E13" //존재하지 않는 데이터
    case rejectRequest = "E15" //요청 거절 -> 워크스페이스 또는 채널의 관리자 권한이 있는경우 퇴장 불가능
}

//워크스페이스 초대
enum InviteWorkspaceError: String, HTTPError {
    case noData = "E13" //존재하지 않는 데이터
    case unknownUser = "E03" //알수없는 계정
    case permissionDenied = "E14" //권한없음 -> 워크스페이스 관리자만 멤버 초대가능
    case wrongRequest = "E11" //잘못된 요청
    case serverConflict = "E12" //중복 데이터
}

// MARK: =======CHANNEL=======

//채널 생성
enum CreateChannelError: String, HTTPError {
    case serverConflict = "E12" //중복데이터
    case noData = "E13" //존재하지 않는 데이터
    case wrongRequest = "E11" //잘못된 요청
}

//채널채팅 생성
enum SendChattingError: String, HTTPError {
    case wrongRequest = "E11" // 잘못된 요청
    case noData = "E13" //존재하지 않는 데이터
}

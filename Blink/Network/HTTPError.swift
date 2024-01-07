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

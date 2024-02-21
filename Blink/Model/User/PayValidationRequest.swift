//
//  PayValidationRequest.swift
//  Blink
//
//  Created by Chaewon on 2/21/24.
//

import Foundation

struct PayValidationRequest: Encodable {
    let imp_uid: String //포트원 거래 고유 번호
    let merchant_uid: String //상점 고유 번호
}

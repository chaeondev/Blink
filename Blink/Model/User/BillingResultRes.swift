//
//  BillingResultRes.swift
//  Blink
//
//  Created by Chaewon on 2/21/24.
//

import Foundation

struct BillingResultRes: Decodable {
    let billing_id: Int
    let merchant_uid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: String
}

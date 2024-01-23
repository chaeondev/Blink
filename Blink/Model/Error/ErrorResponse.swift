//
//  ErrorResponse.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation

struct ErrorResponse: Error, Decodable {
    let errorCode: String
}


//
//  CreateChannel.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import Foundation

struct CreateChannelRequest: Encodable {
    let name: String
    let description: String?
}

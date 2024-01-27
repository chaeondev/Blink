//
//  ChattingTable.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class ChattingTable: Object {
    
    @Persisted(primaryKey: true) var chat_id: Int
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var sender: UserTable
    
    convenience init(chat_id: Int, content: String, createdAt: Date, files: [String], sender: UserTable) {
        self.init()
        
        self.chat_id = chat_id
        self.content = content
        self.createdAt = createdAt
        self.files = List<String>()
        self.files.append(objectsIn: files)
        self.sender = sender
    }
    
}

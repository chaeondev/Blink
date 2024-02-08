//
//  ChannelTable.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class ChannelTable: Object {
    
    @Persisted(primaryKey: true) var channel_id: Int
    @Persisted var workspace_id: Int
    @Persisted var channel_name: String
    
    @Persisted var chattings: List<ChattingTable>
    
    convenience init(channel_id: Int, workspace_id: Int, channel_name: String) {
        self.init()
        
        self.channel_id = channel_id
        self.workspace_id = workspace_id
        self.channel_name = channel_name
    }
}

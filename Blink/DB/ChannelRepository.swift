//
//  ChannelRepository.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class ChannelRepository: RepositoryType {
    
    typealias T = ChannelTable

    private let realm = try! Realm()
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
  
    func fetchAll() -> RealmSwift.Results<ChannelTable> {
        
        return realm.objects(ChannelTable.self)
    }
    
    func updateItem(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: ChannelTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}


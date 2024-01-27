//
//  ChattingRepository.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

class ChattingRepository: RepositoryType {
    
    typealias T = ChattingTable
    
    private let realm = try! Realm()
    
    func checkRealmURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
  
    func fetchAll() -> RealmSwift.Results<ChattingTable> {
        
        let data = realm.objects(ChattingTable.self).sorted(byKeyPath: "createdAt", ascending: true)
        
        return data
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
    
    func deleteItem(_ item: ChattingTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    
}

extension ChattingRepository {
    
    func createItem(_ item: ChattingTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
}

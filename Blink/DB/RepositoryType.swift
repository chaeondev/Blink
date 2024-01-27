//
//  RepositoryType.swift
//  Blink
//
//  Created by Chaewon on 1/27/24.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    
    associatedtype T: Object
    
    func checkRealmURL()
    func fetchAll() -> Results<T>
    func updateItem(completion: () -> Void)
    func deleteItem(_ item: T)
    
}

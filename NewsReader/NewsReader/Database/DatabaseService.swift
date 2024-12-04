//
//  DatabaseService.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

import Foundation
import RealmSwift

class DatabaseService {
    private let storage: Realm?
    
    init(
        _ configuration: Realm.Configuration = Realm.Configuration(
        )
    ) {
        self.storage = try? Realm(configuration: configuration)
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object, update: .modified)
        }
    }
    
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(objects, update: .modified)
        }
    }
    
    func update(closure:(() -> ())) throws {
        guard let storage else { return }
        try storage.write {
            closure()
        }
        
    }
    
    func delete(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object)
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
    
    func fetchResults<T: Object>(by type: T.Type) -> Results<T>? {
        guard let storage else { return nil}
        return storage.objects(T.self)
    }
    
    func fetchObject<T: Object, KeyType>(by type: T.Type, key: KeyType) -> T? {
        guard let storage else { return nil}
        return storage.object(ofType: T.self, forPrimaryKey: key)
    }
    
}

extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}

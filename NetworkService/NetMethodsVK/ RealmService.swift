//
//   RealmService.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 09.06.2021.
//
import RealmSwift

class RealmService {
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T],
                                configuration: Realm.Configuration = deleteIfMigration,
                                update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        
        do {
        try realm.write{
            realm.add(items,
                      update: update)
        }
        }
        catch {
            print(error)
        }
    }
    
    static func load<T:Object>(typeOf: T.Type, sortedKey: String ) throws -> Results<T> {
        print(Realm.Configuration().fileURL ?? "")
        let realm = try Realm()
        let object = realm.objects(T.self).sorted(byKeyPath: sortedKey)
        return object
    }
    
    static func delete<T:Object>(object: Results<T>) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(object)
        }
    }
}

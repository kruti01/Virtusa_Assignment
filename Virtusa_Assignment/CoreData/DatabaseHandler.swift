//
//  DatabaseHandler.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 26/01/23.
//

import UIKit
import CoreData

class DatabaseHandler {
        
    private var viewContext: NSManagedObjectContext!
    
    static let shared = DatabaseHandler()
    
    private init() {
        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func add<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as! [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        viewContext.delete(object)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DatabaseHandler {
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}

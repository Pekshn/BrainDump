//
//  CoreDataManager.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import CoreData

class CoreDataManager {
    
    //MARK: - Properties
    static let shared: CoreDataManager = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    //MARK: - Init
    private init() {
        persistentContainer = NSPersistentContainer(name: "BrainDump")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed Core Data initialization with error: \(error)")
            }
        }
    }
}

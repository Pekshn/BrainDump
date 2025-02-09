//
//  BrainDumpApp.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI

@main
struct BrainDumpApp: App {
    
    //MARK: - Properties
    let persistenceContainer = CoreDataManager.shared.persistentContainer
    
    //MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
        }
    }
}

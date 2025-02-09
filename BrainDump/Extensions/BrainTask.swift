//
//  BrainTask.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import Foundation
import CoreData

extension BrainTask {
    
    //MARK: - All brain tasks request
    static func allBrainTasksRequest() -> NSFetchRequest<BrainTask> {
        let req: NSFetchRequest<BrainTask> = BrainTask.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return req
    }
    
    //MARK: - Get brain task by title
    static func getBrainTaskBy(title: String) -> BrainTask? {
        let req: NSFetchRequest<BrainTask> = BrainTask.fetchRequest()
        req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", title.lowercased())
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let brainTask = try viewContext.fetch(req).first
            return brainTask
        } catch {
            return nil
        }
    }
}

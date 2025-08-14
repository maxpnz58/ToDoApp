//
//  TaskDetailInteractor.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import UIKit
import CoreData

final class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    func createTask(_ task: TaskModel) {
        CoreDataStack.shared.performBackground { ctx in
            let entity = TaskEntity(context: ctx)
            entity.id = task.id
            entity.title = task.title
            entity.details = task.details
            entity.completed = task.completed
            do {
                try ctx.save()
            } catch {
                print("❌ Failed to create task:", error)
            }
        }
    }
    
    func updateTask(_ task: TaskModel) {
        CoreDataStack.shared.performBackground { ctx in
            ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %d", task.id)
            req.fetchLimit = 1

            do {
                if let obj = try ctx.fetch(req).first {
                    obj.title = task.title
                    obj.details = task.details
                    try ctx.save()
                }
            } catch {
                print("❌ Failed to update task:", error)
            }
        }
    }
}

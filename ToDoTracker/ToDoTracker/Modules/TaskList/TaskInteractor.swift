//
//  TaskInteractor.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation
import CoreData

final class TasksInteractor: TasksInteractorProtocol {
    func loadInitialTodos(completion: @escaping () -> Void) {
        let imported = UserDefaults.standard.bool(forKey: "imported")
        guard !imported else {
            completion()
            return
        }

        NetworkService.shared.fetchTodos { result in
            switch result {
            case .success(let todos):
                CoreDataStack.shared.performBackground { ctx in
                    for t in todos {
                        let task = TaskEntity(context: ctx)
                        task.id = Int64(t.id)
                        task.title = t.todo
                        task.details = ""
                        task.completed = t.completed
                        task.userId = Int64(t.userId)
                        task.createdAt = Date()
                    }
                    do {
                        try ctx.save()
                        UserDefaults.standard.set(true, forKey: "imported")
                    } catch {
                        print("❌ Save error:", error)
                    }
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .failure(let error):
                print("❌ Network error:", error)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }



    func fetchAllTasks(completion: @escaping ([TaskModel]) -> Void) {
        DispatchQueue.global().async {
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            let results = (try? CoreDataStack.shared.viewContext.fetch(req)) ?? []
            let models = results.map { TaskModel(entity: $0) }
            DispatchQueue.main.async { completion(models) }
        }
    }

    func createTask(title: String, details: String?) {
        CoreDataStack.shared.performBackground { ctx in
            let t = TaskEntity(context: ctx)
            t.id = Int64(Date().timeIntervalSince1970)
            t.title = title
            t.details = details
            t.createdAt = Date()
            t.completed = false
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
                    obj.completed = task.completed
                } else {
                    print("⚠️ Task with id \(task.id) not found in Core Data")
                }
                try ctx.save()
            } catch {
                print("❌ Failed to update task:", error)
            }
        }
    }


    func searchTasks(query: String, completion: @escaping ([TaskModel]) -> Void) {
        DispatchQueue.global().async {
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@", query, query)
            let results = (try? CoreDataStack.shared.viewContext.fetch(req)) ?? []
            let models = results.map { TaskModel(entity: $0) }
            DispatchQueue.main.async { completion(models) }
        }
    }
}


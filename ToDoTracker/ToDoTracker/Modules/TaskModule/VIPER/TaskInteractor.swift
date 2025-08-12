//
//  TaskInteractor.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation
import CoreData

final class TasksInteractor: TasksInteractorProtocol {
    func loadInitialTodos() {
        let imported = UserDefaults.standard.bool(forKey: "imported")
        guard !imported else { return }
        NetworkService.shared.fetchTodos { result in
            if case .success(let todos) = result {
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
                    UserDefaults.standard.set(true, forKey: "imported")
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
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %d", task.id)
            if let obj = try? ctx.fetch(req).first {
                obj.title = task.title
                obj.details = task.details
                obj.completed = task.completed
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


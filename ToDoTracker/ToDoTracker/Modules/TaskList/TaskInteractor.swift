//
//  TaskInteractor.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation
import CoreData

final class TasksInteractor: TasksInteractorProtocol {
    func loadInitialTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        let imported = UserDefaults.standard.bool(forKey: "imported")
        guard !imported else {
            completion(.success(()))
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
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchAllTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        DispatchQueue.global().async {
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            do {
                let results = try CoreDataStack.shared.viewContext.fetch(req)
                let models = results.map { TaskModel(entity: $0) }
                DispatchQueue.main.async { completion(.success(models)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func updateTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
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
                    throw NSError(domain: "Task not found", code: 404)
                }
                try ctx.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func deleteTask(byId taskId: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataStack.shared.performBackground { ctx in
            ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", taskId)
            fetchRequest.fetchLimit = 1
            
            print("Trying to delete task withId: \(taskId)")
            
            do {
                if let taskToDelete = try ctx.fetch(fetchRequest).first {
                    ctx.delete(taskToDelete)
                    try ctx.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } else {
                    throw NSError(domain: "Task not found", code: 404)
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func searchTasks(query: String, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        DispatchQueue.global().async {
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@", query, query)
            req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            do {
                let results = try CoreDataStack.shared.viewContext.fetch(req)
                let models = results.map { TaskModel(entity: $0) }
                DispatchQueue.main.async { completion(.success(models)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}

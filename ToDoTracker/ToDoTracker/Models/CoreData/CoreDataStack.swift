//
//  CoreDataStack.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "ToDoModel")

    private let container: NSPersistentContainer
    
    private init(modelName: String) {
        
        // Проверяем, что модель существует
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model: \(modelName)")
        }
        
        // Создаём контейнер с явной моделью
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData error: \(error)") }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        

    }

    var viewContext: NSManagedObjectContext { container.viewContext }

    func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { context in
            block(context)
            if context.hasChanges {
                do { try context.save() } catch { print("Save error:", error) }
            }
        }
    }
}

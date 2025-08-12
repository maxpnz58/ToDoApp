//
//  TaskModel.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

struct TaskModel {
    var id: Int64
    var title: String
    var details: String?
    var createdAt: Date
    var completed: Bool

    init(entity: TaskEntity) {
        id = entity.id
        title = entity.title ?? ""
        details = entity.details
        createdAt = entity.createdAt ?? Date()
        completed = entity.completed
    }
    
    // Новый инициализатор для ручного создания модели
    init(id: Int64, title: String, details: String?, createdAt: Date, completed: Bool) {
        self.id = id
        self.title = title
        self.details = details
        self.createdAt = createdAt
        self.completed = completed
    }
}

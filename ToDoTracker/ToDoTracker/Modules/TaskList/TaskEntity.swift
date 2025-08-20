//
//  TaskViewModel.swift
//  ToDoTracker
//
//  Created by Max on 20.08.2025.
//

import Foundation

class TaskViewModel: Hashable {
    let id: Int64
    var title: String
    var description: String
    var dateString: String
    var completed: Bool
    
    init(from model: TaskModel) {
        self.id = model.id
        self.title = model.title
        self.description = model.details ?? "Описание задачи отсутствует"
        self.dateString = model.createdAt.formattedToDMY()
        self.completed = model.completed
    }
    
    // Для diffable: уникальность определяется только id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Для сравнения учитываем ВСЕ данные, влияющие на отображение
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.dateString == rhs.dateString &&
               lhs.completed == rhs.completed
    }
}


//
//  TaskViewModel.swift
//  ToDoTracker
//
//  Created by Max on 20.08.2025.
//

import Foundation

class TaskViewModel: Hashable {
    let id: Int64
    let title: String
    let description: String
    let dateString: String
    var completed: Bool
    
    init(from model: TaskModel) {
        self.id = model.id
        self.title = model.title
        self.description = model.details ?? "Описание задачи отсутствует"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        self.dateString = model.createdAt.formattedToDMY()
        self.completed = model.completed
    }
    
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

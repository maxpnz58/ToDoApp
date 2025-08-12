//
//  ApiModel.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

struct Storage: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

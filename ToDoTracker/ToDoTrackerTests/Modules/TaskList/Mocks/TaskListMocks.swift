//
//  TaskListMocks.swift
//  ToDoTrackerTests
//
//  Created by Max on 20.08.2025.
//

import Foundation

final class MockTasksView: TasksViewProtocol {
    var shownTasks: [TaskViewModel] = []
    var errors: [String] = []
    var deletedIds: [Int64] = []
    var reloadedIds: [Int64] = []
    
    func showTasks(_ tasks: [TaskViewModel]) { shownTasks = tasks }
    func showError(message: String) { errors.append(message) }
    func deleteTask(withId id: Int64) { deletedIds.append(id) }
    func insertTask(with task: TaskViewModel, at index: Int) {}
    func reloadTask(withId id: Int64) { reloadedIds.append(id) }
}

final class MockTasksInteractor: TasksInteractorProtocol {
    var tasks: [TaskModel] = []
    var updateCalledWith: TaskModel?
    var deleteCalledWith: Int64?
    
    func loadInitialTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func fetchAllTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        completion(.success(tasks))
    }
    
    func searchTasks(query: String, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        completion(.success(tasks.filter { $0.title.contains(query) }))
    }
    
    func updateTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        updateCalledWith = task
        completion(.success(()))
    }
    
    func deleteTask(byId taskId: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteCalledWith = taskId
        completion(.success(()))
    }
}

final class MockTasksRouter: TasksRouterProtocol {
    static func createModule() -> TasksViewController {
        return TasksViewController()
    }
    
    var sharedText: String?
    var navigatedTask: TaskModel?
    var navigatedNewTask = false
    
    func presentShare(from view: TasksViewProtocol, text: String) {
        sharedText = text
    }
    
    func navigateToTaskDetail(from view: TasksViewProtocol, with task: TaskModel) {
        navigatedTask = task
    }
    
    func navigateToNewTaskDetail(from view: TasksViewProtocol) {
        navigatedNewTask = true
    }
}




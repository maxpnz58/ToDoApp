//
//  TaskViewProtocol.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

protocol TasksViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskModel])
    func updateTask(at index: Int, with task: TaskModel)
}

protocol TasksPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTask(_ task: TaskModel)
    func didDeleteTask(_ task: TaskModel)
//    func didTapAddTask(title: String, details: String?)
    func didToggleComplete(task: TaskModel)
    func search(query: String)
}

protocol TasksInteractorProtocol: AnyObject {
    func loadInitialTodos(completion: @escaping () -> Void)
    func fetchAllTasks(completion: @escaping ([TaskModel]) -> Void)
    func updateTask(_ task: TaskModel)
    func deleteTask(byId taskId: Int64) 
    func searchTasks(query: String, completion: @escaping ([TaskModel]) -> Void)
}

protocol TasksRouterProtocol: AnyObject {
    static func createModule() -> TasksViewController
    func navigateToTaskDetail(from view: TasksViewProtocol, with task: TaskModel)
}


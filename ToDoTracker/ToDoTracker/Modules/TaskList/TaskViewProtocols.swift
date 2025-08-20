//
//  TaskViewProtocols.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

protocol TasksViewProtocol: AnyObject {
    func showTasks(_ viewModels: [TaskViewModel])
    func reloadTask(withId id: Int64)
    func deleteTask(withId id: Int64)
    func insertTask(with viewModel: TaskViewModel, at index: Int)
    func showError(message: String)
}

protocol TasksPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectTask(id: Int64)
    func didDeleteTask(id: Int64)
    func didTapAddTask()
    func didToggleComplete(id: Int64)
    func search(query: String)
    func didShareTask(_ task: TaskViewModel)
}

protocol TasksInteractorProtocol: AnyObject {
    func loadInitialTodos(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchAllTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func updateTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(byId taskId: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(query: String, completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

protocol TasksRouterProtocol: AnyObject {
    static func createModule() -> TasksViewController
    func navigateToTaskDetail(from view: TasksViewProtocol, with task: TaskModel)
    func navigateToNewTaskDetail(from view: TasksViewProtocol)
    func presentShare(from view: TasksViewProtocol, text: String)
}


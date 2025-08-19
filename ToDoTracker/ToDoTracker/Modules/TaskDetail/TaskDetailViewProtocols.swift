//
//  TaskDetailProtocols.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ viewModel: TaskViewModel)
    func setDate(_ dateString: String)
    func showError(message: String)
}

protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TaskDetailInteractorProtocol: AnyObject {
    func updateTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TaskDetailRouterProtocol: AnyObject {
    static func createModule(with task: TaskModel) -> TaskDetailViewController
    static func createModuleForNewTask() -> TaskDetailViewController
}

protocol TaskDetailDelegate: AnyObject {
    func didCreateTask(_ task: TaskModel)
    func didUpdateTask(_ task: TaskModel)
}

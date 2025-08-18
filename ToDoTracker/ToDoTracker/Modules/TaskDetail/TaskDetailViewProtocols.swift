//
//  TaskDetailProtocols.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ task: TaskModel)
//    func showError(_ message: String)
}

protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateTask(title: String, description: String?)
    func currentTask() -> TaskModel
    func prepareForNewTask()
}

protocol TaskDetailInteractorProtocol: AnyObject {
    func updateTask(_ task: TaskModel)
    func createTask(_ task: TaskModel)
}

protocol TaskDetailRouterProtocol: AnyObject {
    static func createModule(with task: TaskModel) -> TaskDetailViewController
}

protocol TaskDetailDelegate: AnyObject {
    func taskDidUpdate(_ task: TaskModel)
}

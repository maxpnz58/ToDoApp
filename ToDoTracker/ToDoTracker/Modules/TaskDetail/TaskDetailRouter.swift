//
//  TaskDetailRouter.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

final class TaskDetailRouter: TaskDetailRouterProtocol {
    static func createModule(with task: TaskModel) -> TaskDetailViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(task: task)
        let interactor = TaskDetailInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor

        return view
    }
    
    static func createModuleForNewTask() -> TaskDetailViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(task: nil)
        let interactor = TaskDetailInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        
        view.configureForNewTask()

        return view
    }
}

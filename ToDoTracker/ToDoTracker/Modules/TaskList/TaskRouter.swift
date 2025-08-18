//
//  TaskRouter.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import UIKit

final class TasksRouter: TasksRouterProtocol {
    static func createModule() -> TasksViewController {
        let view = TasksViewController()
        let presenter = TasksPresenter()
        let interactor = TasksInteractor()
        let router = TasksRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        return view
    }
    
    func navigateToTaskDetail(from view: TasksViewProtocol, with task: TaskModel) {
        let detailVC = TaskDetailRouter.createModule(with: task)
        if let viewVC = view as? UIViewController {
            detailVC.delegate = viewVC as? TaskDetailDelegate
            viewVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


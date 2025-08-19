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
    
    func navigateToTaskDetail(from view: TasksViewProtocol, with taskId: Int64) {
        // Assuming TaskDetailRouter.createModule(withId: Int64) or load TaskModel if needed
        // For simplicity, assume it creates with id, and loads inside
//        let detailVC = TaskDetailRouter.createModule(with: taskId)
        if let viewVC = view as? UIViewController {
//            viewVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func navigateToNewTaskDetail(from view: TasksViewProtocol) {
        let detailVC = TaskDetailRouter.createModuleForNewTask()
        if let presenter = detailVC.presenter as? TaskDetailPresenter,
           let tasksPresenter = (view as? TasksViewController)?.presenter as? TasksPresenter {
            presenter.delegate = tasksPresenter
        }
        (view as? UIViewController)?.navigationController?.pushViewController(detailVC, animated: true)
    }
}




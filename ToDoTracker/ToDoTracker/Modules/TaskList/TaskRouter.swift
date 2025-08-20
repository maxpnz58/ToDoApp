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
            viewVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func navigateToNewTaskDetail(from view: TasksViewProtocol) {
        let detailVC = TaskDetailRouter.createModuleForNewTask()
        if let viewVC = view as? UIViewController {
            viewVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func presentShare(from view: TasksViewProtocol, text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        // Для iPad (чтобы не падало)
        if let popover = activityVC.popoverPresentationController {
            if let vc = view as? UIViewController {
                popover.sourceView = vc.view
                popover.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
        }

        (view as? UIViewController)?.present(activityVC, animated: true)
    }
}




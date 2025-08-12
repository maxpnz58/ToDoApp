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
}


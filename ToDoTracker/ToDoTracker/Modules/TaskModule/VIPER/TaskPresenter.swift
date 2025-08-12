//
//  TaskPresenter.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

final class TasksPresenter: TasksPresenterProtocol {
    weak var view: TasksViewProtocol?
    var interactor: TasksInteractorProtocol?
    var router: TasksRouterProtocol?

    func viewDidLoad() {
        interactor?.loadInitialTodos()
        interactor?.fetchAllTasks { [weak self] tasks in
            self?.view?.showTasks(tasks)
        }
    }

    func didSelectTask(_ task: TaskModel) {
        // Навигация на детали через router
    }

    func didTapAddTask(title: String, details: String?) {
        interactor?.createTask(title: title, details: details)
        viewDidLoad()
    }

    func didToggleComplete(task: TaskModel) {
        var updated = task
        updated = TaskModel(id: task.id, title: task.title, details: task.details, createdAt: task.createdAt, completed: !task.completed)
        interactor?.updateTask(updated)
        viewDidLoad()
    }

    func search(query: String) {
        interactor?.searchTasks(query: query) { [weak self] tasks in
            self?.view?.showTasks(tasks)
        }
    }
}

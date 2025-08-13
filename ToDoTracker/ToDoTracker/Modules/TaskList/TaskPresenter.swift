//
//  TaskPresenter.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

final class TasksPresenter: TasksPresenterProtocol {
    weak var view: TasksViewProtocol?
    var interactor: TasksInteractorProtocol?
    var router: TasksRouterProtocol?

    private var tasks: [TaskModel] = []

    func viewDidLoad() {
        interactor?.loadInitialTodos { [weak self] in
            self?.fetchTasks()
        }
    }

    private func fetchTasks() {
        interactor?.fetchAllTasks { [weak self] tasks in
            self?.view?.showTasks(tasks)
        }
    }

    func didSelectTask(_ task: TaskModel) {
        // Навигация на детали через router
    }

    func didTapAddTask(title: String, details: String?) {
        interactor?.createTask(title: title, details: details)
        // После создания получаем задачу из Core Data и добавляем в массив
        fetchTasks()
    }

    func didToggleComplete(task: TaskModel) {
        interactor?.updateTask(task)
        // Обновляем локально массив
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            view?.updateTask(at: index, with: task)
        }
    }

    func search(query: String) {
        interactor?.searchTasks(query: query) { [weak self] tasks in
            self?.tasks = tasks
            self?.view?.showTasks(tasks)
        }
    }
}

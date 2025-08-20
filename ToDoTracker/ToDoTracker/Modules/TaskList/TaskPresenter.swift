//
//  TaskPresenter.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import UIKit

final class TasksPresenter: TasksPresenterProtocol {
    
    weak var view: TasksViewProtocol?
    var interactor: TasksInteractorProtocol?
    var router: TasksRouterProtocol?
    
    private var tasks: [TaskModel] = []
    private var currentQuery: String = ""

    func viewDidLoad() {
        interactor?.loadInitialTodos { [weak self] result in
            if case .failure(let error) = result {
                self?.view?.showError(message: error.localizedDescription)
            }
            self?.search(query: "")
        }
    }
    
    func viewWillAppear() {
        search(query: currentQuery)
    }

    func didSelectTask(id: Int64) {
        guard let view = view,
              let task = tasks.first(where: { $0.id == id }) else { return }
        router?.navigateToTaskDetail(from: view, with: task)
    }
    
    func didTapAddTask() {
        guard let view = view else { return }
        router?.navigateToNewTaskDetail(from: view)
    }

    func didDeleteTask(id: Int64) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        let oldTask = tasks[index]
        tasks.remove(at: index)
        view?.deleteTask(withId: id)
        interactor?.deleteTask(byId: id) { [weak self] result in
            if case .failure(let error) = result {
                self?.tasks.insert(oldTask, at: index)
                self?.view?.insertTask(with: TaskViewModel(from: oldTask), at: index)
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func didToggleComplete(id: Int64) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        let oldTask = tasks[index]
        var newTask = oldTask
        newTask.completed.toggle()
        tasks[index] = newTask
        view?.updateTask(withId: id, viewModel: TaskViewModel(from: newTask))
        interactor?.updateTask(newTask) { [weak self] result in
            if case .failure(let error) = result {
                self?.tasks[index] = oldTask
                self?.view?.updateTask(withId: id, viewModel: TaskViewModel(from: oldTask))
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func search(query: String) {
        currentQuery = query
        let fetchCompletion: (Result<[TaskModel], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let fetchedTasks):
                self?.tasks = fetchedTasks
                let viewModels = fetchedTasks.map { TaskViewModel(from: $0) }
                self?.view?.showTasks(viewModels)
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
        if query.isEmpty {
            interactor?.fetchAllTasks(completion: fetchCompletion)
        } else {
            interactor?.searchTasks(query: query, completion: fetchCompletion)
        }
    }
}

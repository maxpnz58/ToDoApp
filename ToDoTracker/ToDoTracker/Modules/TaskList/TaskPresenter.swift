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
    
    private var taskViewModels: [TaskViewModel] = []
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
              let taskModel = taskViewModels.first(where: { $0.id == id }).map({ TaskModel(id: $0.id, title: $0.title, details: $0.description == "Описание задачи отсутствует" ? nil : $0.description, createdAt: Date(), completed: $0.completed) }) else { return }  // Конверт back to TaskModel
        router?.navigateToTaskDetail(from: view, with: taskModel)
    }
    
    func didTapAddTask() {
        guard let view = view else { return }
        router?.navigateToNewTaskDetail(from: view)
    }

    func didDeleteTask(id: Int64) {
        guard let index = taskViewModels.firstIndex(where: { $0.id == id }) else { return }
        let oldVM = taskViewModels[index]
        taskViewModels.remove(at: index)
        view?.deleteTask(withId: id)
        interactor?.deleteTask(byId: id) { [weak self] result in
            if case .failure(let error) = result {
                self?.taskViewModels.insert(oldVM, at: index)
                self?.view?.insertTask(with: oldVM, at: index)
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func didToggleComplete(id: Int64) {
        guard let vm = taskViewModels.first(where: { $0.id == id }) else { return }
        let oldCompleted = vm.completed
        vm.completed.toggle()
        view?.reloadTask(withId: id)
        let taskModel = TaskModel(id: id, title: vm.title, details: vm.description == "Описание задачи отсутствует" ? nil : vm.description, createdAt: Date(), completed: vm.completed)  // Конверт to TaskModel for save
        interactor?.updateTask(taskModel) { [weak self] result in
            if case .failure(let error) = result {
                vm.completed = oldCompleted
                self?.view?.reloadTask(withId: id)
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func search(query: String) {
        currentQuery = query
        let fetchCompletion: (Result<[TaskModel], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let fetchedTasks):
                self?.taskViewModels = fetchedTasks.map { TaskViewModel(from: $0) }
                self?.view?.showTasks(self?.taskViewModels ?? [])
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
    
    func didShareTask(_ task: TaskViewModel) {
        let textToShare = """
        📌 Задача: \(task.title)
        📝 Описание: \(task.description == "" ? "отсутствует" : task.description)
        ⏰ Дата: \(task.dateString)
        ✅ Выполнена: \(task.completed ? "Да" : "Нет")
        """
        if let view = view {
            router?.presentShare(from: view, text: textToShare)
        }
    }
}

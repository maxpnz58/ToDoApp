//
//  TaskDetailPresenter.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    weak var delegate: TaskDetailDelegate?
    
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol?
    
    private var task: TaskModel?
    private var isNewTask: Bool = false

    init(task: TaskModel?) {
        self.task = task
        self.isNewTask = (task == nil)
    }

    func viewDidLoad() {
        if let task = task {
            view?.showTask(TaskViewModel(from: task))
        }
    }

    func didUpdateTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        if isNewTask {
            let newTask = TaskModel(id: (Int64(Date().timeIntervalSince1970)), title: title, details: description, createdAt: Date(), completed: false)
            print("created task with: newTask \(newTask)")
            interactor?.createTask(newTask) { [weak self] result in
                if case .success = result {
                    self?.delegate?.didCreateTask(newTask)
                }
                completion(result)
            }
        } else if var updatedTask = task {
            updatedTask.title = title
            updatedTask.details = description
            interactor?.updateTask(updatedTask) { [weak self] result in
                if case .success = result {
                    self?.delegate?.didUpdateTask(updatedTask)
                }
                completion(result)
            }
        }
    }
}

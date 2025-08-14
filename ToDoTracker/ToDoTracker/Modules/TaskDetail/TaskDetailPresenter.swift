//
//  TaskDetailPresenter.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol?
    
    private var task: TaskModel
    
    private var isNewTask = false

    init(task: TaskModel) {
        self.task = task
    }

    func viewDidLoad() {
        view?.showTask(task)
    }

    func didUpdateTask(title: String, description: String?) {
        task.title = title
        task.details = description
        interactor?.updateTask(task)
    }
    
    func currentTask() -> TaskModel {
        return task
    }
    
    func prepareForNewTask() {
        task = TaskModel(id: UUID().positiveInt64Value, title: "Заголовок", details: "Описание", createdAt: Date(), completed: false)
        interactor?.createTask(task)
    }
}

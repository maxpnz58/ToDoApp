//
//  TaskViewController.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import UIKit

final class TasksViewController: UIViewController, TasksViewProtocol {
    var presenter: TasksPresenterProtocol?
    private var tasks: [TaskModel] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.backgroundColor = .systemBackground
        setupTableView()
        presenter?.viewDidLoad()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)

    }

    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
    }
    
    private func toggleTaskCompletion(at indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        task.completed.toggle()
        // Сохраняем в Core Data через interactor/presenter
        presenter?.didToggleComplete(task: task)
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tasks.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        
        cell.configure(
            title: task.title,
            description: task.details ?? "Описание задачи отсутствует", // заглушка
            date: task.createdAt,
            completed: task.completed
        )
        
        cell.onToggleComplete = { [weak self] in
            self?.toggleTaskCompletion(at: indexPath)
        }
        
        return cell
    }
}


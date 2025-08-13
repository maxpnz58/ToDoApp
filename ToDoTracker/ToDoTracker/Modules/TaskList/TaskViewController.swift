//
//  TaskViewController.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import UIKit

final class TasksViewController: UIViewController {

    var presenter: TasksPresenterProtocol?
    private var tasks: [TaskModel] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
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
    
    private func toggleTaskCompletion(taskID: Int) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        
        // Обновляем модель в массиве
        tasks[index].completed.toggle()
        
        // Отправляем в Core Data через Presenter
        presenter?.didToggleComplete(task: tasks[index])
        
        // Обновляем UI только для изменённой строки
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tasks.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        
        cell.configure(
            title: task.title,
            description: task.details ?? "Описание задачи отсутствует",
            date: task.createdAt,
            completed: task.completed
        )
        
        // Обновляем состояние через Presenter
        cell.onToggleComplete = { [weak self] in
            guard let self = self else { return }
            var updatedTask = self.tasks[indexPath.row]
            updatedTask.completed.toggle()
            self.tasks[indexPath.row] = updatedTask
            self.presenter?.didToggleComplete(task: updatedTask)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    private func configureNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFProText-Bold", size: 32) ?? .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let detailVC = TaskDetailRouter.createModule(with: task)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TasksViewController: TasksViewProtocol {
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
    }

    func updateTask(at index: Int, with task: TaskModel) {
        guard index < tasks.count else { return }
        tasks[index] = task
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension TasksViewController: TaskDetailDelegate {
    func taskDidUpdate(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

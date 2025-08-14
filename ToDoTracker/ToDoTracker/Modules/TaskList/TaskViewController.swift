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
    private var filteredTasks: [TaskModel] = []
    private var isSearching = false
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let addButton = UIButton(type: .system)
    private let countLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupBottomBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func configureNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFProText-Bold", size: 32) ?? .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
    }
    
    private func setupBottomBar() {
        // Серый подвал
        bottomBar.backgroundColor = .systemGray5
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Счётчик задач по центру
        countLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Кнопка добавить задачу
        let circleImage = UIImage(named: "newTaaskIcon")
        addButton.setImage(circleImage!.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        addButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomBar)
        bottomBar.addSubview(countLabel)
        bottomBar.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 84),
            
            countLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: bottomBar.topAnchor,constant: 13),
            addButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -22),
            addButton.widthAnchor.constraint(equalToConstant: 25),
            addButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func updateCounter() {
        countLabel.text = "\(tasks.count) Задач"
    }
    
    @objc private func addTaskTapped() {
        let detailVC = TaskDetailViewController()
        detailVC.configureForNewTask()
        navigationController?.pushViewController(detailVC, animated: true)
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
        updateCounter()
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

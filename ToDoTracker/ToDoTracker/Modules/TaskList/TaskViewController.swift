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
    
    private let topBar = UIView()
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let addButton = UIButton(type: .system)
    private let countLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTopBar()
        setupBottomBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupTopBar() {
        // Серый чердак
        topBar.backgroundColor = .systemBackground
        topBar.translatesAutoresizingMaskIntoConstraints = false

        // Надпись Задачи:
        titleLabel.text = "Задачи"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFProText-Bold", size: 32) ?? .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // SearchBar
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font =  UIFont(name: "SFProText-Regular", size: 18)
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(topBar)
        topBar.addSubview(titleLabel)
        topBar.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor,constant: -8),
            searchBar.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -12),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
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
        let circleImage = UIImage(named: "newTaskIcon")
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
        let count = isSearching ? filteredTasks.count : tasks.count
        countLabel.text = "\(count) Задач"
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredTasks.count : tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        
        cell.configure(
            title: task.title,
            description: task.details ?? "Описание задачи отсутствует",
            date: task.createdAt,
            completed: task.completed
        )
        
        cell.onToggleComplete = { [weak self] in
            guard let self = self else { return }
            var updatedTask = task
            updatedTask.completed.toggle()
            if let idx = self.tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks[idx] = updatedTask
            }
            self.presenter?.didToggleComplete(task: updatedTask)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.updateCounter()
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

extension TasksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredTasks.removeAll()
        } else {
            isSearching = true
            filteredTasks = tasks.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                ($0.details?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
        tableView.reloadData()
        updateCounter()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
        updateCounter()
    }
}

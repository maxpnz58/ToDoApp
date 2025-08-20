//
//  TaskViewController.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import UIKit

final class TasksViewController: UIViewController {

    var presenter: TasksPresenterProtocol?
    
    private let topBar = UIView()
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let addButton = UIButton(type: .system)
    private let countLabel = UILabel()
    
    private var dataSource: UITableViewDiffableDataSource<Section, TaskViewModel>!
    private enum Section: Hashable {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTopBar()
        setupBottomBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    private func setupTopBar() {
        topBar.backgroundColor = .systemBackground
        topBar.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Задачи"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFProText-Bold", size: 32) ?? .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font = UIFont(name: "SFProText-Regular", size: 18)
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        dataSource = UITableViewDiffableDataSource<Section, TaskViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TaskTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? TaskTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(
                title: viewModel.title,
                description: viewModel.description,
                date: viewModel.dateString,
                completed: viewModel.completed
            )
            
            cell.onToggleComplete = { [weak self] in
                self?.presenter?.didToggleComplete(id: viewModel.id)
            }
            
            return cell
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
    }
    
    private func setupBottomBar() {
        bottomBar.backgroundColor = .systemGray5
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let circleImage = UIImage(named: "newTaskIcon")
        addButton.setImage(circleImage?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        let count = dataSource.snapshot().numberOfItems
        countLabel.text = "\(count) Задач"
    }
    
    @objc private func addTaskTapped() {
        presenter?.didTapAddTask()
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter?.didSelectTask(id: viewModel.id)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let viewModel = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
            guard let self = self else { return nil }

            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.didSelectTask(id: viewModel.id)
            }

            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.didShareTask(viewModel)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("Удалить \(viewModel.title)")
                self.presenter?.didDeleteTask(id: viewModel.id)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { }
    }
}

extension TasksViewController: TasksViewProtocol {
    func showTasks(_ viewModels: [TaskViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TaskViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: false)
        updateCounter()
    }
    
    func reloadTask(withId id: Int64) {
        var snapshot = dataSource.snapshot()
        if let item = snapshot.itemIdentifiers.first(where: { $0.id == id }) {
            snapshot.reloadItems([item])
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        updateCounter()
    }
    
    func deleteTask(withId id: Int64) {
        var snapshot = dataSource.snapshot()
        if let item = snapshot.itemIdentifiers.first(where: { $0.id == id }) {
            snapshot.deleteItems([item])
            dataSource.apply(snapshot)
        }
        updateCounter()
    }
    
    func insertTask(with viewModel: TaskViewModel, at index: Int) {
        var snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers(inSection: .main)
        if index < items.count {
            let referenceItem = items[index]
            snapshot.insertItems([viewModel], beforeItem: referenceItem)
        } else {
            snapshot.appendItems([viewModel])
        }
        dataSource.apply(snapshot)
        updateCounter()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TasksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter?.search(query: "")
    }
}

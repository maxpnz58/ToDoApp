//
//  TaskDetailViewController.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController {

    var presenter: TaskDetailPresenterProtocol?

    private let titleField = UITextField()
    private let dateLabel = UILabel()
    private let descriptionField = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        // Название задачи:
        titleField.borderStyle = .none
        titleField.placeholder = "Название задачи"
        titleField.textAlignment = .left
        titleField.font = UIFont(name: "SFProText-Bold", size: 32)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        
        // Дата создания задачи
        dateLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        dateLabel.numberOfLines = 1
        dateLabel.alpha = 0.5
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Описание задачи
        descriptionField.font = UIFont(name: "SFProText-Regular", size: 16)
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionField)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 41),
            
            dateLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            
            descriptionField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            descriptionField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTask))
    }

    @objc private func saveTask() {
        let title = titleField.text ?? ""
        let description = descriptionField.text
        presenter?.didUpdateTask(title: title, description: description) { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func configureForNewTask() {
        titleField.text = ""
        descriptionField.text = ""
        setDate(Date().formattedToDMY())
    }
}

extension TaskDetailViewController: TaskDetailViewProtocol {
    func showTask(_ viewModel: TaskViewModel) {
        titleField.text = viewModel.title
        descriptionField.text = viewModel.description
        dateLabel.text = viewModel.dateString
    }
    
    func setDate(_ dateString: String) {
        dateLabel.text = dateString
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

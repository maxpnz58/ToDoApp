//
//  TaskDetailViewController.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController, TaskDetailViewProtocol {

    
    weak var delegate: TaskDetailDelegate?
    
    var presenter: TaskDetailPresenterProtocol?

    private let titleField = UITextField()
    private let descriptionField = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        titleField.borderStyle = .roundedRect
        titleField.placeholder = "Title"
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionField.layer.cornerRadius = 8

        [titleField, descriptionField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleField.heightAnchor.constraint(equalToConstant: 40),

            descriptionField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            descriptionField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            descriptionField.heightAnchor.constraint(equalToConstant: 200)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
    }

    func showTask(_ task: TaskModel) {
        titleField.text = task.title
        descriptionField.text = task.details
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func saveTapped() {
        let title = titleField.text ?? ""
        let description = descriptionField.text
        presenter?.didUpdateTask(title: title, description: description)
        
        // Уведомляем делегата что что - то поменялось и нужно перерисовать ui
        if let updatedTask = presenter?.currentTask() {
            delegate?.taskDidUpdate(updatedTask)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension TaskDetailViewController {
    @objc func configureForNewTask() {
        // Сбрасываем текстовые поля
        titleField.text = ""
        descriptionField.text = ""
        
        // Настраиваем заголовок навигации
        navigationItem.title = "New Task"
        
        // Сообщаем презентеру, что создаём новую задачу
        presenter?.prepareForNewTask()
    }
}

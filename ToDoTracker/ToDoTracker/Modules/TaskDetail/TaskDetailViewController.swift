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
    private let dateLabel = UILabel()
    private let descriptionField = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        //  Название задачи:
        titleField.borderStyle = .none
        titleField.placeholder = "Название задачи"
        titleField.textAlignment = .left
        titleField.font = UIFont(name: "SFProText-Bold", size: 32)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        
        //Дата создания задачи
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
    }

    func showTask(_ task: TaskModel) {
        titleField.text = task.title
        descriptionField.text = task.details
        dateLabel.text = task.createdAt.formattedToDMY()
    }

    @objc private func saveTask() {
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
        dateLabel.text = ""
        descriptionField.text = ""
        // Сообщаем презентеру, что создаём новую задачу
        presenter?.prepareForNewTask()
    }
}

// Автосохранение заметки при выходе из VC
extension TaskDetailViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            saveTask()
        }
    }
}

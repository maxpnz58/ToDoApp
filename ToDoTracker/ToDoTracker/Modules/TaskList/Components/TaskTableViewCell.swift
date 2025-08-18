//
//  TaskTableViewCell.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TaskTableViewCell"
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .custom)
        let circleImage = UIImage(named: "circle")
        button.setImage(circleImage!.withRenderingMode(.alwaysOriginal), for: .normal)
        let circleTickImage = UIImage(named: "circle.tick")
        button.setImage(circleTickImage!.withRenderingMode(.alwaysOriginal), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Medium", size: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.numberOfLines = 1
        label.alpha = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onToggleComplete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        completeButton.isSelected = false
        onToggleComplete = nil
    }
    
    private func setupUI() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        completeButton.addTarget(self, action: #selector(toggleComplete), for: .touchUpInside)
        
        // Включаем autoresizing mask в констрейнты
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Высота contentView
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 106),
            
            // Констрейнты для completeButton
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 24),
            completeButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Констрейнты для titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            
            // Констрейнты для descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 32),
            
            // Констрейнты для dateLabel
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4)
        ])
    }
    
    @objc private func toggleComplete() {
        onToggleComplete?()
    }
    
    @objc private func setStrikethrough(to label: UILabel, isStrikethrough: Bool) {
        guard let text = label.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        if isStrikethrough {
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length)
            )
        } else {
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.thick,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }
        
        label.attributedText = attributedString
    }
    
    func configure(title: String, description: String, date: Date, completed: Bool) {
        // Конфим текст заголовка
        titleLabel.text = title
        titleLabel.alpha = completed ? 0.5 : 1
        setStrikethrough(to: titleLabel, isStrikethrough: completed)
        
        // Конфим текст описания задачи
        descriptionLabel.text = (description != "") ? description : "🤷‍♂️ Ой! API has no description text to the tasks! But you can add It yourself 📄✨"
        descriptionLabel.alpha = completed ? 0.5 : 1
        
        // Конфим дату создания
        dateLabel.text = date.formattedToDMY()
        
        // Конфим UI состояние кнопки
        completeButton.isSelected = completed
    }
}

import SwiftUI
// Обертка для отображения TaskTableViewCell в SwiftUI Preview
struct TaskTableViewCellRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: TaskTableViewCell, context: Context) {}
    
    let completed: Bool
    
    func makeUIView(context: Context) -> TaskTableViewCell {
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.reuseIdentifier)
        let sampleDate = Date()
        cell.configure(
            title: "Sample Task",
            description: "This is a sample description for the task.",
            date: sampleDate,
            completed: completed
        )
        return cell
    }
}

// SwiftUI Preview
#Preview("TaskTableViewCell - Not Completed") {
    TaskTableViewCellRepresentable(completed: false)
        .frame(width: 350, height: 150) // Устанавливаем размеры для превью
        .padding()
}

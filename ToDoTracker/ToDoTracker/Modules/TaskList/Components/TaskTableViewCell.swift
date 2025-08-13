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
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onToggleComplete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
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
        // Устанавливаем текст titleLabel
        titleLabel.text = title
        // Применяем зачеркивание
        setStrikethrough(to: titleLabel, isStrikethrough: completed)
        // Устанавливаем descriptionLabel после titleLabel
        descriptionLabel.text = String(repeating: title, count: 10)
        // Устанавливаем дату
        dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        // Обновляем UI кнопки
        completeButton.isSelected = completed
        completeButton.tintColor = completed ? .systemGreen : .systemGray
    }
}

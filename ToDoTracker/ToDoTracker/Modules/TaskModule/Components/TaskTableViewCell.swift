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
        button.tintColor = .systemBlue
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
    
    private func setupUI() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        completeButton.addTarget(self, action: #selector(toggleComplete), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 150),
            
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            completeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completeButton.widthAnchor.constraint(equalToConstant: 24),
            completeButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -3),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    @objc private func toggleComplete() {
        onToggleComplete?()
    }
    
    @objc private func addStrikethrough(to label: UILabel) {
        guard let text = label.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length),
        )
        label.attributedText = attributedString
    }
    
    func configure(title: String, description: String, date: Date, completed: Bool) {
        titleLabel.text = title
        dateLabel.text = date.formatted()
        descriptionLabel.text = "Lorem ipsum dolor sit amet. Aut officia maxime et odit dolorem cum rerum saepe est fuga maxime eum quae iusto. Aut eligendi accusantium qui inventore voluptatem ea quas impedit cum earum deleniti rem dolores nihil non laborum illum. Nam error perferendis est quam culpa ut distinctio animi qui nulla quam et consequatur voluptatem 33 molestias nostrum."
        let imageName = completed ? "checkmark.circle.fill" : "circle"
        completeButton.setImage(UIImage(systemName: imageName), for: .normal)
        completeButton.tintColor = completed ? .systemGreen : .systemGray
        if completed {addStrikethrough(to: titleLabel)}
    }
}

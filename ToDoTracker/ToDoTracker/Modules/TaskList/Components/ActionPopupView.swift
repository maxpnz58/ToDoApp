//
//  ActionPopupView.swift
//  ToDoTracker
//
//  Created by Max on 14.08.2025.
//

import UIKit

final class ActionPopupView: UIView {

    // MARK: - Action model
    struct Action {
        let title: String
        let systemImage: String
        let color: UIColor
        let handler: () -> Void
    }

    // MARK: - Properties
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    private let container = UIStackView()
    
    // MARK: - Init
    init(actions: [Action]) {
        super.init(frame: UIScreen.main.bounds)
        setupBlur()
        setupContainer()
        setupActions(actions)
        animateIn()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup UI
    private func setupBlur() {
        blurView.frame = bounds
        blurView.alpha = 0
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        
        // Tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        blurView.addGestureRecognizer(tap)
    }

    private func setupContainer() {
        container.axis = .vertical
        container.spacing = 0
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupActions(_ actions: [Action]) {
        for (index, action) in actions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.setImage(UIImage(systemName: action.systemImage), for: .normal)
            button.tintColor = action.color
            button.setTitleColor(action.color, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.backgroundColor = .secondarySystemBackground
            button.contentHorizontalAlignment = .right
            button.semanticContentAttribute = .forceRightToLeft
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            if index != actions.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                let stack = UIStackView(arrangedSubviews: [button, separator])
                stack.axis = .vertical
                container.addArrangedSubview(stack)
            } else {
                container.addArrangedSubview(button)
            }
            
            button.addAction(UIAction { [weak self] _ in
                self?.dismiss()
                action.handler()
            }, for: .touchUpInside)
        }
    }

    // MARK: - Animations
    private func animateIn() {
        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 1
        }
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurView.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

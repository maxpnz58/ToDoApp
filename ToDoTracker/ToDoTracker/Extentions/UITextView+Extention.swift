//
//  UITetView+Extention.swift
//  ToDoTracker
//
//  Created by Max on 18.08.2025.
//

import UIKit

private var placeholderLabelKey: UInt8 = 0
private var placeholderObserverKey: UInt8 = 1

class PlaceholderObserver: NSObject {
    weak var textView: UITextView?

    init(textView: UITextView) {
        self.textView = textView
        super.init()
        textView.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }

    deinit {
        textView?.removeObserver(self, forKeyPath: "text")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            textView?.placeholderLabel?.isHidden = !(textView?.text.isEmpty ?? true)
        }
    }
}

extension UITextView {
     var placeholderLabel: UILabel? {
        get { objc_getAssociatedObject(self, &placeholderLabelKey) as? UILabel }
        set { objc_setAssociatedObject(self, &placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var placeholderObserver: PlaceholderObserver? {
        get { objc_getAssociatedObject(self, &placeholderObserverKey) as? PlaceholderObserver }
        set { objc_setAssociatedObject(self, &placeholderObserverKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setPlaceholder(_ text: String, color: UIColor = .placeholderText) {
        if placeholderLabel == nil {
            let label = UILabel()
            label.textColor = color
            label.font = self.font
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
            ])
            self.placeholderLabel = label

            self.placeholderObserver = PlaceholderObserver(textView: self)
        }
        placeholderLabel?.text = text
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    func updatePlaceholderVisibility() {
        placeholderLabel?.isHidden = !text.isEmpty
    }
}

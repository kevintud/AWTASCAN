//
//  KeyboardHandlingViewController.swift
//  AWTAScan
//
//  Created by Kevin on 3/8/25.
//

import UIKit

/// Protocol for handling keyboard events
protocol KeyboardHandlerDelegate: AnyObject {
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
}

/// Helper class that listens to keyboard events and informs its delegate
class KeyboardHandler {
    
    weak var delegate: KeyboardHandlerDelegate?
    
    init(delegate: KeyboardHandlerDelegate) {
        self.delegate = delegate
        setupKeyboardNotifications()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            delegate?.keyboardWillShow(height: keyboardFrame.height)
        }
    }
    
    @objc private func keyboardWillHide() {
        delegate?.keyboardWillHide()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//
//  Extensions.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import UIKit

extension UITextView {
    func adjustableForKeyboard() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - safeAreaInsets.bottom,
                right: 0
            )
        }

        scrollIndicatorInsets = contentInset
        scrollRangeToVisible(selectedRange)
    }
}

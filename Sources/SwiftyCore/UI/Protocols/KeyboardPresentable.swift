//
//  KeyboardPresentable.swift
//  CommonCore
//
//  Created by Borko Tomic on 06/11/2020.
//
import Foundation
import UIKit

public protocol KeyboardPresentable: class {
    func keyboardAboutToShow(keyboardSize: CGRect, duration: CGFloat, curve: UIView.AnimationCurve?)
    func keyboardAboutToHide(keyboardSize: CGRect, duration: CGFloat, curve: UIView.AnimationCurve?)
}

public class KeyboardPresenter {
    public static var shared = KeyboardPresenter()
    private var presenters = [KeyboardPresentable]()

    private let frameKey = UIResponder.keyboardFrameEndUserInfoKey
    private let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
    private let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
    
    init() {
        registerForKeyboardNotifications()
    }
    
    public func add(presenter: KeyboardPresentable) {
        if !presenters.contains(where: { $0 === presenter }) {
            presenters.append(presenter)
        }
    }
    
    public func remove(presenter: KeyboardPresentable) {
        presenters.removeAll(where: { $0 === presenter })
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        let duration = notification.userInfo?[durationKey] as? CGFloat ?? 0.0
        let curveValue = notification.userInfo?[curveKey] as? Int
        let curve = curveValue != nil ? UIView.AnimationCurve(rawValue: curveValue!) : nil
        if let keyboardSize = (notification.userInfo?[frameKey] as? NSValue)?.cgRectValue {
            for presenter in presenters {
                presenter.keyboardAboutToShow(keyboardSize: keyboardSize, duration: duration, curve: curve)
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[durationKey] as? CGFloat ?? 0.0
        let curveValue = notification.userInfo?[curveKey] as? Int
        let curve = curveValue != nil ? UIView.AnimationCurve(rawValue: curveValue!) : nil
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            for presenter in presenters {
                presenter.keyboardAboutToHide(keyboardSize: keyboardSize, duration: duration, curve: curve)
            }
        }
    }
}

//
//  Alertable.swift
//  CommonCore
//
//  Created by Borko Tomic on 04/11/2020.
//

import Foundation
import UIKit

public protocol Alertable where Self: UIViewController {
    func showOKAlert(with title: String, and text: String, confirmButtonText: String, tag: String)
    func didPressOk(on tag: String)
}

public extension Alertable {
    func showOKAlert(with title: String, and text: String, confirmButtonText: String = "OK", tag: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okHandler = { (action: UIAlertAction) in self.didPressOk(on: tag) }
        alert.addAction(UIAlertAction(title: confirmButtonText, style: .default, handler: okHandler))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

protocol MultiSelectionAlertable where Self: UIViewController {
    func didSelect(item: PickerItem)
    func showAlert(with options: [PickerItem])
}

extension MultiSelectionAlertable {
    func showAlert(with title: String, and text: String, cancelOptionText: String? = "Cancel", with options: [PickerItem]) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        for item in options {
            let handler = { (action: UIAlertAction) in self.didSelect(item: item) }
            alert.addAction(UIAlertAction(title: item.title, style: .default, handler: handler))
        }
        
        alert.addAction(UIAlertAction(title: cancelOptionText, style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

protocol Confirmable where Self: UIViewController {
    func showConfirmAlert(with title: String, and text: String, confirmButtonText: String, cancelButtonText: String, isDelete: Bool, tag: Int)
    func didConfirm(on tag: Int)
    func didCancel(on tag: Int)
}

extension Confirmable {
    func showConfirmAlert(with title: String, and text: String, confirmButtonText: String, cancelButtonText: String = "Cancel", isDelete: Bool = false, tag: Int) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let confirmHandler = { (action: UIAlertAction) in self.didConfirm(on: tag) }
        let cancelHandler = { (action:UIAlertAction) in self.didCancel(on: tag) }
        let confirmAction = UIAlertAction(title: confirmButtonText, style: isDelete ? .destructive : .default , handler: confirmHandler)
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: cancelButtonText, style: .cancel , handler: cancelHandler))
        alert.preferredAction = alert.actions.first(where: { $0 == confirmAction })
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func didCancel(on tag: Int) {}
}

protocol ReasonConfirmable where Self: UIViewController {
    func showConfirmWithInput(title: String, text: String, confirmButtonText: String, isNumbersInput: Bool, inputPlaceholder: String?, isDelete: Bool, tag: Int)
    func didConfirm(on tag: Int, with reason: String)
    func didCancel(on tag: Int)
}

extension ReasonConfirmable {
    func showConfirmWithInput(title: String, text: String, confirmButtonText: String, cancelButtonText: String? = "Cancel", isNumbersInput: Bool = false, inputPlaceholder: String? = nil, isDelete: Bool = true, tag: Int) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = inputPlaceholder
            textField.delegate = alert
            textField.keyboardType = isNumbersInput ? .phonePad : .default
        }
        let confirmHandler = { (action: UIAlertAction) in
            guard let reasonTextField = alert.textFields?[0], let text = reasonTextField.text else { return }
            self.didConfirm(on: tag, with: text)
        }
        let cancelHandler = { (action:UIAlertAction) in self.didCancel(on: tag) }
        alert.addAction(UIAlertAction(title: confirmButtonText, style: isDelete ? .destructive : .default , handler: confirmHandler))
        alert.actions[0].isEnabled = false
        alert.addAction(UIAlertAction(title: cancelButtonText, style: .cancel , handler: cancelHandler))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

//
//  UIAlertController+Extension.swift
//  CommonCore
//
//  Created by Borko Tomic on 04/11/2020.
//

import Foundation
import UIKit

extension UIAlertController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            for action in actions where action.style != .cancel {
                action.isEnabled = !updatedText.isEmpty
            }
        }
        return true
    }
}

//
//  String+Extension.swift
//  
//
//  Created by Borko Tomic on 10.12.20..
//

import Foundation


public extension String {
    var localized: String {
        let stringToReturn = NSLocalizedString(self, comment: "")
//        guard stringToReturn != self else {
//            return "Missing key"
//        }
//        guard !stringToReturn.isEmpty else {
//            return "No Translation"
//        }
        return stringToReturn
    }
    
    func isValidEmailAddress() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        guard self.count > 8 else { return false }
        var hasUpperLetter = false
        var hasCharacter = false
        var hasNumber = false
        
        for char in self {
            if char.isLetter {
                hasCharacter = true
            }
            if char.isUppercase {
                hasUpperLetter = true
            }
            if char.isNumber {
                hasNumber = true
            }
        }
        return hasUpperLetter && hasCharacter && hasNumber
    }
    
    func isNumeric() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
}

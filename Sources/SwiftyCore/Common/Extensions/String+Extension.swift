//
//  String+Extension.swift
//  
//
//  Created by Borko Tomic on 20.1.21..
//

import Foundation

public extension String {
    
    static func createTimeStringFromSeconds(_ seconds: Int) -> String {
        [seconds/3600, (seconds%3600)/60, (seconds%3600)%60]
            .map({ String(format: "%02d", $0) })
            .joined(separator: ":")
            .deletingPrefix("00:")
    }
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
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
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

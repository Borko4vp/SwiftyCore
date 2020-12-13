//
//  UIColor+Extension.swift
//  
//
//  Created by Borko Tomic on 22.11.20..
//

import Foundation
import UIKit

public extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        let offset = hex.hasPrefix("#") ? 1 : 0
        let start = hex.index(hex.startIndex, offsetBy: offset)
        let hexColor = String(hex[start...])
        guard hexColor.count == 6 else { return nil }
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255

            self.init(red: r, green: g, blue: b, alpha: 1.0)
            return
        }
        return nil
    }
}

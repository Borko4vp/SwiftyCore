//
//  File.swift
//  
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

extension UIView {
    public func addShadow(opacity: CGFloat, radius: CGFloat, offset: CGSize = .zero) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}

//
//  UIView+Extension.swift
//  
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

extension UIView {
    public var animationDuration: Double {  return 0.25 }
    public func addShadow(opacity: CGFloat, radius: CGFloat, offset: CGSize = .zero) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    public func animate(duration: Double? = nil, block: @escaping () -> Void, completion: (() -> Void)? = nil) {
        let duration = duration ?? animationDuration
        UIView.animate(withDuration: duration, animations: {
            block()
            self.layoutIfNeeded()
        }, completion: { success in
            completion?()
        })
    }
}

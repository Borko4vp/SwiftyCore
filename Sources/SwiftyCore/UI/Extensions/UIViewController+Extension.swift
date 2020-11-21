//
//  UIViewController+Extension.swift
//  CommonCore
//
//  Created by Borko Tomic on 20/11/2020.
//

import Foundation
import UIKit

extension UIViewController: Animatable {
    var animationDuration: Double {
        return 0.5
    }
    
    func animate(duration: Double? = nil, block: @escaping () -> Void, completion: (() -> Void)? = nil) {
        let duration = duration ?? animationDuration
        UIView.animate(withDuration: duration, animations: {
            block()
            self.view.layoutIfNeeded()
        }, completion: { success in
            completion?()
        })
    }
}

//
//  File.swift
//  
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

public extension UIDevice {
    static var isBiggerScreenDevice: Bool {
        return UIScreen.main.bounds.size.height > 700
    }
    
    static var isWiderScreenDevice: Bool {
        return UIScreen.main.bounds.size.width > 400
    }
    
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
        return bottom > 0
    }
}

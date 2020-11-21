//
//  File.swift
//  
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

extension UIDevice {
    public static var isBiggerScreenDevice: Bool {
        return UIScreen.main.bounds.size.height > 800
    }
    
    public static var isWiderScreenDevice: Bool {
        return UIScreen.main.bounds.size.width > 400
    }
    
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

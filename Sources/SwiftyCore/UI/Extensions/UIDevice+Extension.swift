//
//  UIDevice+Extension.swift
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
        return UIScreen.main.bounds.size.width > 380
    }
    
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
        return bottom > 0
    }
    
    static var is5sSize: Bool {
        return UIScreen.main.bounds.size.height == 568
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows[0].safeAreaInsets
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
}


/*       SIZES :
 
12 Pro Max:                         428 x 926
Xr, 11, Xs Max, 11 Pro Max:         414 x 896
12, 12 Pro:                         390 x 844
X,  Xs, 11 Pro, 12 mini:            375 x 812
6 Plus, 6s Plus, 7 Plus, 8 Plus:    414 x 736
6, 6s, 7, 8, SE(2nd):               375 x 667
5s, SE(1st):                        320 x 568
*/

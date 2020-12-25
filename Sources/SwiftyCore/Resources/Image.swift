//
//  File.swift
//  
//
//  Created by Borko Tomic on 25.12.20..
//

import Foundation
import UIKit

enum Image: String {
    case galleryPlaceholder
    case avatarPlaceholder
    case circlePlay
    case circleStop
    
    var uiImage: UIImage {
        return UIImage(named: rawValue, in: Bundle.module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }
}

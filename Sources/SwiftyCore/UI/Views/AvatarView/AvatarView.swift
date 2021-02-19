//
//  File.swift
//  
//
//  Created by Borko Tomic on 15.1.21..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    public class AvatarView {
        private var avatar: AvatarViewInternal
        
        public init(rect: CGRect, backColor: UIColor, cornerRadius: CGFloat? = nil, circleWidth: Int = 0, placeholderImage: UIImage? = nil) {
            avatar = AvatarViewInternal.instanceFromNib(with: rect)
            avatar.setTheme(backColor: backColor, cornerRadius: cornerRadius, circleWidth: circleWidth, placeholderImage: placeholderImage)
        }
        
        public func set(image: String) {
            avatar.set(image: image)
        }
        
        public var view: UIView { return avatar }
    }
}

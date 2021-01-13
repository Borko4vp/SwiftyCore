//
//  File.swift
//  
//
//  Created by Borko Tomic on 11.1.21..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    public class ProgressView {
        private var progressBar: ProgressViewInternal
        
        public init(rect: CGRect, color: UIColor, backColor: UIColor) {
            progressBar = ProgressViewInternal.instanceFromNib(with: rect)
            progressBar.setTheme(with: color, backColor: backColor)
        }
        
        public func setProgress(percent: Double) {
            progressBar.setProgress(percent: percent)
        }
        
        public var view: UIView { return progressBar }
    }
}


//
//  ProgressView.swift
//  iVault
//
//  Created by Borko Tomic on 25.12.20..
//

import Foundation
import UIKit

class ProgressViewInternal: UIView {
    class func instanceFromNib(with frame: CGRect) -> ProgressViewInternal {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.progressViewInternal.instantiate(withOwner: self, options: nil)[0] as! ProgressViewInternal
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.layoutIfNeeded()
        return xibView
    }
    
    @IBOutlet private weak var totalProgressView: UIView!
    @IBOutlet private weak var currentProgressView: UIView!
    @IBOutlet private weak var currentProgressViewWidthCst: NSLayoutConstraint!
    
    private func setup() {
        totalProgressView.layer.cornerRadius = totalProgressView.bounds.height/2
        currentProgressView.layer.cornerRadius = currentProgressView.bounds.height/2
    }
    
    public func setTheme(with color: UIColor, backColor: UIColor) {
        setup()
        totalProgressView.backgroundColor = backColor
        currentProgressView.backgroundColor = color
    }
    
    public func setProgress(percent: Double) {
        let multiply: CGFloat = CGFloat(100 - percent)/CGFloat(100)
        currentProgressViewWidthCst.constant = -CGFloat(multiply*totalProgressView.bounds.width)
        setNeedsLayout()
    }
}

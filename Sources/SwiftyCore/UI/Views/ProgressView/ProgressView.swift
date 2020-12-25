//
//  ProgressView.swift
//  iVault
//
//  Created by Borko Tomic on 25.12.20..
//

import Foundation
import UIKit

public class ProgressView: UIView {
    class func instanceFromNib(with frame: CGRect) -> ProgressView {
        let xibView = SwiftyCore.UI.Views.Nibs.progressView.instantiate(withOwner: self, options: nil)[0] as! ProgressView
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
    
    public func setProgress(percent: Double) {
        setup()
        let multiply: CGFloat = CGFloat(100 - percent)/CGFloat(100)
        currentProgressViewWidthCst.constant = -CGFloat(multiply*totalProgressView.bounds.width)
        setNeedsLayout()
    }
    
}

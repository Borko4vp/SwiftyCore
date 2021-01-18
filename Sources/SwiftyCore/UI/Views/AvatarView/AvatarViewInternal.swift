//
//  AvatarViewInternal.swift
//  iVault
//
//  Created by Borko Tomic on 16.1.21..
//

import Foundation
import UIKit

class AvatarViewInternal: UIView {
    
    @IBOutlet private weak var imageBackView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var avatarImageTopCst: NSLayoutConstraint!
    @IBOutlet private weak var avatarImageLeadingCst: NSLayoutConstraint!
    
    private var placeholderImage: UIImage?
    
    class func instanceFromNib(with frame: CGRect) -> AvatarViewInternal {
        let xibView = SwiftyCore.UI.Views.Nibs.avatarViewInternal.instantiate(withOwner: self, options: nil)[0] as! AvatarViewInternal
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.layoutIfNeeded()
        return xibView
    }
    
    func setTheme(backColor: UIColor, circleWidth: Int, placeholderImage: UIImage?) {
        imageBackView.layer.cornerRadius = imageBackView.bounds.height/2
        imageBackView.backgroundColor = backColor
        avatarImageTopCst.constant = CGFloat(circleWidth)
        avatarImageLeadingCst.constant = CGFloat(circleWidth)
        avatarImageView.layer.cornerRadius = (imageBackView.bounds.height - 2*CGFloat(circleWidth))/2
        self.placeholderImage = placeholderImage
    }
    
    func set(image: String) {
        avatarImageView.setRemoteImage(from: image, placeholderImage: placeholderImage)
    }
}

//
//  ImageMessageView.swift
//  iVault
//
//  Created by Borko Tomic on 18.12.20..
//

import UIKit

class ImageMessageView: UIView {
    class func instanceFromNib(with frame: CGRect) -> ImageMessageView {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.imageMessageView.instantiate(withOwner: self, options: nil)[0] as! ImageMessageView
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.layoutIfNeeded()
        return xibView
    }

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    
    func set(image url: URL) {
        imageView.setRemoteImage(from: url.absoluteString)
        imageView.layer.cornerRadius = SwiftyCore.UI.Chat.cornerRadius
        layoutIfNeeded()
    }

}

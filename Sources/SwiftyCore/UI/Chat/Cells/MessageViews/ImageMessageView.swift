//
//  ImageMessageView.swift
//  SwiftyCore
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
    
    
    func set(image url: URL, tintColor: UIColor = .lightGray) {
        imageView.setRemoteImage(from: url.absoluteString, placeholderImage: Image.galleryPlaceholder.uiImage)
        imageView.layer.cornerRadius = SwiftyCore.UI.Chat.bubbleCornerRadius
        imageView.tintColor = tintColor
        layoutIfNeeded()
    }

}

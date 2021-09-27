//
//  ImageMessageView.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 18.12.20..
//

import UIKit

protocol ImageMessageViewDelegate: AnyObject {
    func didTapImage(with url: String)
}

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
    
    private weak var imageMessageViewDelegate: ImageMessageViewDelegate?
    private var urlString: String?
    
    func set(image url: URL, requestHeaders: [String: String]? = nil, tintColor: UIColor = .lightGray, delegate: ImageMessageViewDelegate) {
        imageMessageViewDelegate = delegate
        urlString = url.absoluteString
        imageView.setRemoteImage(from: url.absoluteString, headers: requestHeaders, placeholderImage: Image.galleryPlaceholder.uiImage)
        imageView.layer.cornerRadius = SwiftyCore.UI.Chat.bubbleCornerRadius
        imageView.tintColor = tintColor
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        layoutIfNeeded()
    }
    
    @objc
    private func imageTapped() {
        guard let url = urlString else { return }
        imageMessageViewDelegate?.didTapImage(with: url)
    }

}

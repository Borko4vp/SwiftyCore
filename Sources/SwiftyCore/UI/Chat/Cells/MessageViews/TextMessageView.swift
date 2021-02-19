//
//  TextMessageView.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 9.12.20..
//

import UIKit


class TextMessageView: UIView {
    class func instanceFromNib(with frame: CGRect) -> TextMessageView {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.textMessageView.instantiate(withOwner: self, options: nil)[0] as! TextMessageView
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.layoutIfNeeded()
        return xibView
    }
    
    @IBOutlet private weak var textLabel: UILabel!
    
    var textColor: UIColor = .black {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    func set(with text: String, color: UIColor, font: UIFont) {
        textLabel.text = text
        textLabel.font = font
        textColor = color
        textLabel.sizeToFit()
        layoutIfNeeded()
    }
}

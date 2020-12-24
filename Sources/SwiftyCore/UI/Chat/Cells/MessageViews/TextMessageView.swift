//
//  HomeHeaderView.swift
//  iVault
//
//  Created by Borko Tomic on 9.12.20..
//

import UIKit


class TextMessageView: UIView {
    class func instanceFromNib(with frame: CGRect) -> TextMessageView {
        let xibView = UINib(nibName: "TextMessageView", bundle: Bundle.module).instantiate(withOwner: self, options: nil)[0] as! TextMessageView
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
    
    func set(with text: String, color: UIColor) {
        textLabel.text = text
        textColor = color
        textLabel.sizeToFit()
        layoutIfNeeded()
    }
}

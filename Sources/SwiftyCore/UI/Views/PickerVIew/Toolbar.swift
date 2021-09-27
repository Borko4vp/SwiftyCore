//
//  VToolbar.swift
//  iVault
//
//  Created by Borko Tomic on 7.4.21..
//

import Foundation
import UIKit

public protocol ToolbarPresentable: AnyObject {
    func toolbar(with tag: Int) -> Toolbar?
    
    func donePressed(with tag: Int)
    func cancelPressed(with tag: Int)
}

public class Toolbar: UIToolbar {
    fileprivate weak var toolbarDelegate: ToolbarPresentable!
    fileprivate  var placeholderLabel: UIBarButtonItem!
    fileprivate  var cancelButton: UIBarButtonItem!
    fileprivate  var doneButton: UIBarButtonItem!

    /// Constructor
    ///
    /// - Parameter title: toolbar title
    public init(title: String, delegate: ToolbarPresentable, tag: Int = 0, color: UIColor = .blue) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbarDelegate = delegate
        barTintColor = color
        self.tag = tag
        
        placeholderLabel = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        placeholderLabel.tintColor = UIColor.white
        placeholderLabel.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
        placeholderLabel.title = title
        
        let imageClose = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        cancelButton = UIBarButtonItem(image: imageClose, style: .plain, target: self, action: #selector(onCancel))
        cancelButton.tintColor = UIColor.white
        
        let imageDone = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        doneButton = UIBarButtonItem(image: imageDone, style: .plain, target: self, action: #selector(onDone))
        doneButton.tintColor = UIColor.white
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        items = [cancelButton, spacer, placeholderLabel, spacer, doneButton]
        sizeToFit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc
    fileprivate func onCancel() {
        toolbarDelegate?.cancelPressed(with: tag)
    }

    @objc
    fileprivate func onDone() {
        toolbarDelegate?.donePressed(with: tag)
    }
}

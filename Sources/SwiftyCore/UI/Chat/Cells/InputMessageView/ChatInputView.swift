//
//  File.swift
//  
//
//  Created by Borko Tomic on 18.2.21..
//

import Foundation
import UIKit

public protocol InputMessageViewDelegate: class {
    func didSend(with text: String)
    func didToggleRecording(active: Bool)
    func didPressImage()
}

extension SwiftyCore.UI.Chat {
    public class ChatInputView {
        private var chatInternalView: InputMessageView
        
        public init(rect: CGRect, delegate: InputMessageViewDelegate) {
            chatInternalView = InputMessageView.instanceFromNib(with: rect, delegate: delegate)
        }
        
        public var view: UIView { return chatInternalView }
        
        public func set(keyboardOpen: Bool) {
            chatInternalView.set(keyboardOpen: keyboardOpen)
        }
        
        public func resign() {
            chatInternalView.resign()
        }
    }
}

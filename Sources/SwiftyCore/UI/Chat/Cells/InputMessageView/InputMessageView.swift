//
//  AddCommentView.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 15.1.21..
//

import UIKit

class InputMessageView: UIView {
        
    enum SendButtonState: String {
        case voice
        case sendActive
        case sendInactive
        
        var image: UIImage {
            switch self {
            case .voice: return SwiftyCore.UI.Chat.voiceButtonIcon
            case .sendActive: return SwiftyCore.UI.Chat.sendActiveIcon
            case .sendInactive: return SwiftyCore.UI.Chat.sendInactiveIcon
            }
        }
    }

    class func instanceFromNib(with frame: CGRect, delegate: InputMessageViewDelegate) -> InputMessageView {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.inputMessageView.instantiate(withOwner: self, options: nil)[0] as! InputMessageView
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let newFrame = CGRect(origin: xibView.frame.origin, size: CGSize(width: frame.width, height: xibView.frame.height))
        xibView.frame = newFrame
        xibView.inputMessageViewDelegate = delegate
        xibView.layoutIfNeeded()
        return xibView
    }
    
    override var intrinsicContentSize: CGSize {
        let textHeight = messageField.bounds.height + 20
        return CGSize(width: self.bounds.width, height: textHeight)
    }
    
    private weak var inputMessageViewDelegate: InputMessageViewDelegate?
    private var voiceSupported: Bool = SwiftyCore.UI.Chat.voiceMessagesSupported
    private var imageSupported: Bool = SwiftyCore.UI.Chat.imageMessagesSupported
    
    @IBOutlet private weak var addCommentBackView: UIView!
    @IBOutlet private weak var messageField: GrowingTextView!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var fieldBorderView: UIView!
    
    private var currentButtonState: SendButtonState = .sendActive {
        didSet {
            guard currentButtonState != oldValue else { return }
            DispatchQueue.main.async {
                self.sendButton.setImage(self.currentButtonState.image, for: .normal)
                self.sendButton.isEnabled = self.currentButtonState != .sendInactive
            }
        }
    }
    
    private func updateButtonStatus() {
        if messageField.text.isEmpty {
            if !messageField.isFirstResponder { currentButtonState = voiceSupported ? .voice : .sendInactive }
            else { currentButtonState = .sendInactive }
        } else {
            currentButtonState = .sendActive
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageField.text = ""
        messageField.layer.borderWidth = 0
        messageField.delegate = self
        addCommentBackView.addShadow(opacity: 0.5, radius: 4)
        sendButton.layer.cornerRadius = sendButton.bounds.height/2
        fieldBorderView.layer.cornerRadius = (sendButton.bounds.height + 8)/2
        fieldBorderView.layer.borderWidth = 1
        currentButtonState = voiceSupported ? .voice : .sendInactive
        
        // set custom attributes
        messageField.placeholder = SwiftyCore.UI.Chat.inputMessagePlaceholder
        messageField.placeholderColor = SwiftyCore.UI.Chat.inputMessagePlaceholderColor
        messageField.textColor = SwiftyCore.UI.Chat.inputMessageTextColor
        fieldBorderView.layer.borderColor = SwiftyCore.UI.Chat.inputFieldBorderColor.cgColor
    }
    
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        if currentButtonState == .sendActive {
            inputMessageViewDelegate?.didSend(with: messageField.text)
            messageField.text = ""
            updateButtonStatus()
        } else if currentButtonState == .voice {
            inputMessageViewDelegate?.didToggleRecording(active: true)
        }
    }
    
    @IBAction private func imageButtonAction(_ sender: UIButton) {
        inputMessageViewDelegate?.didPressImage()
    }
}

extension InputMessageView: GrowingTextViewDelegate {
    public func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        updateButtonStatus()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        updateButtonStatus()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updateButtonStatus()
    }
}


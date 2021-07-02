//
//  AddCommentView.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 15.1.21..
//

import UIKit
import AVFoundation

class InputMessageView: UIView {
    
    static var initialSize: CGFloat = 38 + (UIDevice.hasNotch ? 32 : 16) + 12
    enum SendButtonState: String {
        case voice
        case voiceActive
        case sendActive
        case sendInactive
        
        var image: UIImage {
            switch self {
            case .voice: return SwiftyCore.UI.Chat.voiceButtonIcon
            case .voiceActive: return SwiftyCore.UI.Chat.activeVoiceButtonIcon
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
    
    var keyboardOpen: Bool = false
    
    override public var intrinsicContentSize: CGSize {
        let textHeight = messageField.bounds.height + (keyboardOpen ? 8 : (UIDevice.hasNotch ? 32 : 16)) + 12
        return CGSize(width: self.bounds.width, height: textHeight)
    }
    
    private weak var inputMessageViewDelegate: InputMessageViewDelegate?
    private var voiceSupported: Bool = SwiftyCore.UI.Chat.voiceMessagesSupported
    private var imageSupported: Bool = SwiftyCore.UI.Chat.imageMessagesSupported
    
    private var isRecordingActive: Bool = false
    private var currentRecordingFile: URL?
    private var audioRecorder: AVAudioRecorder?
    
    @IBOutlet private weak var addCommentBackView: UIView!
    @IBOutlet private weak var messageField: GrowingTextView!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var fieldBorderView: UIView!
    @IBOutlet private weak var inutFieldBottomCst: NSLayoutConstraint!
    
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
        messageField.font = SwiftyCore.UI.Chat.inputMessageFont
        fieldBorderView.layer.borderColor = SwiftyCore.UI.Chat.inputFieldBorderColor.cgColor
        inutFieldBottomCst.constant = keyboardOpen ? 8 : (UIDevice.hasNotch ? 32 : 16)
        
//        if voiceSupported {
//            requestRecordingPermissions()
//        }
    }
    
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        if currentButtonState == .sendActive {
            inputMessageViewDelegate?.didSend(with: messageField.text)
            messageField.text = ""
            updateButtonStatus()
        } else if [.voice, .voiceActive].contains(currentButtonState) && voiceSupported {
            if !isRecordingActive {
                requestRecordingPermissions()
            } else {
                setRecordingStatus()
            }
        }
    }
    
    func setRecordingStatus() {
        isRecordingActive.toggle()
        inputMessageViewDelegate?.didToggleRecording(active: isRecordingActive, recordingURL: nil)
        updateRecordingUi()
        isRecordingActive ? startRecording() : finishRecording(success: true)
    }
    
    @IBAction private func imageButtonAction(_ sender: UIButton) {
        inputMessageViewDelegate?.didPressImage()
    }
    
    func set(keyboardOpen: Bool) {
        self.keyboardOpen = keyboardOpen
        updateInputFieldBottomCst()
    }
    
    private func updateInputFieldBottomCst() {
        inutFieldBottomCst.constant = keyboardOpen ? 8 : (UIDevice.hasNotch ? 32 : 16)
        layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    func resign() {
        messageField.resignFirstResponder()
    }
    
    func clearInputField() {
        messageField.text = nil
    }
    
    private func updateRecordingUi() {
        //AudioServicesPlaySystemSound(1016)
        
        currentButtonState = isRecordingActive ? .voiceActive : .voice
        messageField.text = isRecordingActive ? SwiftyCore.UI.Chat.recordingVoiceText : ""
        messageField.isUserInteractionEnabled = !isRecordingActive
        sendButton.tintColor = isRecordingActive ? .systemRed : .lightGray
    }
}

extension InputMessageView: GrowingTextViewDelegate {
    public func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        // empty for now
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

// MARK: - Recording
extension InputMessageView {
    private var recordingSession: AVAudioSession { return AVAudioSession.sharedInstance() }
    private var recordingFile: URL { return FileHelper.newMessageUrl }
    private var recordingSettings: [String: Any] {
        return [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    }
    
    private func requestRecordingPermissions() {
        do {
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                print("allowed\(allowed)")
                DispatchQueue.main.async {
                    if allowed {
                        //self.loadRecordingUI()
                        self.setRecordingStatus()
                    } else {
                        // failed to record!
                        self.inputMessageViewDelegate?.showVoicePermissionError()
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording() {
        currentRecordingFile = recordingFile
        try? recordingSession.setCategory(.playAndRecord, mode: .default)
        guard let recorder = try? AVAudioRecorder(url: currentRecordingFile!, settings: recordingSettings) else {
            print("recording failed")
            return
        }
        audioRecorder = recorder
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil

        guard success else {
            //canceled
            inputMessageViewDelegate?.didToggleRecording(active: false, recordingURL: nil)
            print("recording failed :(")
            return
        }
        guard let current = currentRecordingFile else { return }
        inputMessageViewDelegate?.didToggleRecording(active: false, recordingURL: current)
    }
}

extension InputMessageView: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard !flag else { return }
        finishRecording(success: false)
    }
}

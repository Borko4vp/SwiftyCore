//
//  MessagesViewController.swift
//  iVault
//
//  Created by Borko Tomic on 25.3.21..
//

import UIKit

public class MessagesViewController: SwiftyCore.UI.BaseViewController, ImagePickerPresentable {
    
    @IBOutlet private weak var messagesTableView: UITableView!
    @IBOutlet private weak var chatTitleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var headerBackView: UIView!
    private var customInputView: SwiftyCore.UI.Chat.ChatInputView?
    public var messagesDataSource: [SwiftyCore.UI.Chat.Message] = mockDataSource
    
    private var keyboardShown: Bool = false
    private var lastKeyboardHeight: CGFloat?
    
    public override var inputAccessoryView: UIView? {
        if customInputView == nil {
            // initial setup of input accessory view
            let height = SwiftyCore.UI.Chat.ChatInputView.initialHeight
            let rect = CGRect(origin: CGPoint(x: 0, y: view.bounds.height - height), size: CGSize(width: view.bounds.width, height: height))
            let customInputView = SwiftyCore.UI.Chat.ChatInputView(rect: rect, delegate: self)
            customInputView.view.frame = rect
            self.customInputView = customInputView
        }
        return customInputView?.view
    }
    public var imagePicker: ImagePicker!
    private var voiceRecordingURL: URL?
    private var canBecomeFirstResponderLocal = true
    public override var canBecomeFirstResponder: Bool { canBecomeFirstResponderLocal }
    public override var canResignFirstResponder: Bool { true }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setImage(SwiftyCore.UI.Chat.chatBackButtonImage, for: .normal)
        toggleKeyboardEvents(true)
        hidesBottomBarWhenPushed = true
        configureImagePicker()
        setupTableView()
        messagesTableView.backgroundColor = .clear
        view.backgroundColor = SwiftyCore.UI.Chat.chatBackgroundColor
    }
    
    private func closeKeyboard() {
        resignFirstResponder()
        customInputView?.resign()
    }
    
    private func setupTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.keyboardDismissMode = .interactive
        messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messagesTableView.allowsSelection = false
        messagesTableView.separatorStyle = .none
        messagesTableView.register(SwiftyCore.UI.Cells.Nibs.incomingMessageCell, forCellReuseIdentifier: SwiftyCore.UI.Cells.Idents.incomingMessageCell)
        messagesTableView.register(SwiftyCore.UI.Cells.Nibs.outgoingMessageCell, forCellReuseIdentifier: SwiftyCore.UI.Cells.Idents.outgoingMessageCell)
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    public override func keyboardAboutToShow(keyboardSize: CGRect, duration: CGFloat, curve: UIView.AnimationCurve?) {
        print("height: \(keyboardSize.height), duration: \(duration)")
        guard keyboardSize.height > 150 else { return }
        let inputHeight = SwiftyCore.UI.Chat.ChatInputView.initialHeight
        let offsetChange = keyboardSize.height - inputHeight
        guard (duration) > 0 else {
            if keyboardShown && (keyboardSize.height != (lastKeyboardHeight ?? 0)) {
                // special case with duration 0 is when changing keyboard from text to smiley or similar
                lastKeyboardHeight = keyboardSize.height
                self.messagesTableView.setContentOffset(CGPoint(x: 0, y: -offsetChange-inputHeight), animated: true)
                self.messagesTableView.contentInset = UIEdgeInsets(top: offsetChange, left: 0, bottom: 0, right: 0)
            }
            return
        }
        
        lastKeyboardHeight = keyboardSize.height
        guard !keyboardShown else { return }
        
        animateWithKeyboard(duration: duration, curve: curve) {
            self.customInputView?.set(keyboardOpen: keyboardSize.height > 150)
            self.messagesTableView.setContentOffset(CGPoint(x: 0, y: -offsetChange), animated: true)
            self.messagesTableView.contentInset = UIEdgeInsets(top: offsetChange, left: 0, bottom: 0, right: 0)
        }

        keyboardShown = true
    }
    
    public override func keyboardAboutToHide(keyboardSize: CGRect, duration: CGFloat, curve: UIView.AnimationCurve?) {
        //guard keyboardSize.height > 150 else { return }
        animateWithKeyboard(duration: duration, curve: curve) {
            self.customInputView?.set(keyboardOpen: false)
            self.messagesTableView.contentInset = .zero
        }
        keyboardShown = false
        lastKeyboardHeight = nil
    }
}

extension MessagesViewController: InputMessageViewDelegate {
    
    public func didSend(with text: String) {
        print("send: \(text)")
    }
    
    public func didToggleRecording(active: Bool, recordingURL: URL?) {
        if active {
            print("voice recoridng started")
        } else {
            print("voice recoridng finished")
            voiceRecordingURL = recordingURL
            let title = "Please select".localized
            let message = "Chose what to do with recording?".localized
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let sendHandler = { (action: UIAlertAction) in }
            alert.addAction(UIAlertAction(title: "Send".localized, style: .default, handler: sendHandler))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    public func didPressImage() {
        closeKeyboard()
        showImagePicker()
    }
}

extension MessagesViewController: MessageCellDelegate {
    public func didTapOnAvatar(with url: String?) {
        print("Avatar tapped")
    }
    
    public func didTapOnCellBackground(with message: SwiftyCore.UI.Chat.Message) {
        closeKeyboard()
    }
    
    public func didTapOnImageMessage(with url: String?) {
        print("image message tapped")
    }
}


extension MessagesViewController {
    public var imagePickerStrings: ImagePickerStrings {
        ImagePickerStrings(title: "Please select", message: "Chose image source", cameraTitle: "Camera", libraryTitle: "Photo library", cancel: "Cancel")
    }
    
    public var mediaTypes: [ImagePickingType] { [.image] }
    
    public var sourceTypes: [UIImagePickerController.SourceType] {
        return [.camera, .photoLibrary]
    }
    
    public var imagePickerEditing: Bool { true }
    
    public func imagePickerDidSelect(image: UIImage?) {
        // TODO: -
    }
    
    public func imagePickerDidSelect(video url: URL?) {
        //
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesDataSource[indexPath.row]
        let isMine = false//(message.user?.name ?? "") == ApiHandler.loggedUser?.fullName
        let ident = isMine ? SwiftyCore.UI.Cells.Idents.outgoingMessageCell : SwiftyCore.UI.Cells.Idents.incomingMessageCell
        let cell = tableView.dequeueReusableCell(withIdentifier: ident) as! MessageCell
        cell.set(with: message, delegate: self)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MessageCell)?.didEndDisplaying()
    }
}


var mockDataSource: [Message] = [Message(type: .text, timestamp: Date(), message: "A", userName: "Jasmina Kostic"),
                                 Message(type: .text, timestamp: Date(), message: "zzZZzzz", userName: "Jasmina Kostic"),
                                 Message(type: .text, timestamp: Date(), message: "Ako ovo proradiddddddiiiiiiiiiiiiiiiiiiiiiiiiiii", userName: "Borko Tomic"),
                                 Message(type: .text, timestamp: Date(), message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,labore et dolore mag aliqua.", userName: "borko4vp"),
                                 Message(type: .text, timestamp: Date(), message: "eiusmod tempor incididunt ut labore et dolore magna.", userName: "borko4vp"),
                                Message(type: .image, asset: URL(string: "https://picsum.photos/id/2/1024"), userName: "Jasmina Kostic"),
                                Message(type: .image, asset: URL(string: "https://picsum.photos/id/3/1024"), userName: "Jasmina Kostic"),
                                Message(type: .image, asset: URL(string: "https://picsum.photos/id/4/1024"), userName: "Jasmina Kostic"),
                                Message(type: .image, asset: URL(string: "https://picsum.photos/id/5/1024"), userName: "Jasmina Kostic"),
                                Message(type: .image, asset: URL(string: "https://picsum.photos/id/2/1024"), userName: "Jasmina Kostic")/*,
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/3/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/4/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/5/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/2/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/3/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/4/1024"), userName: "Jasmina Kostic"),
                                Message(type: .voice, asset: URL(string: "https://picsum.photos/id/5/1024"), userName: "Jasmina Kostic")*/]

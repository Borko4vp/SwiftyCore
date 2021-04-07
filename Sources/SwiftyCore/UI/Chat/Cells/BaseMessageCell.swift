//
//  BaseMessageCell.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

typealias Message = SwiftyCore.UI.Chat.Message

public protocol MessageCellDelegate: class {
    func didTapOnAvatar(with url: String?)
    func didTapOnCellBackground(with message: SwiftyCore.UI.Chat.Message)
    func didTapOnImageMessage(with url: String?)
}

class BaseMessageCell: UITableViewCell {
    var currentAvatarSize: CGSize?
    var message: Message?
    var avatar: SwiftyCore.UI.AvatarView?
    weak var messageCellDelegate: MessageCellDelegate?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = SwiftyCore.UI.Chat.timstampDateFormat
        return formatter
    }
    
    func getTimestampString(from message: Message) -> String {
        if let dateString = message.timestampString {
            return dateString
        } else if let date = message.timestamp {
            return dateFormatter.string(from: date)
        } else {
            return "no timestamp"
        }
    }
    
    @objc
    func avatarTapped() {
        // Should be overritten in concrete message cell class
    }
    
    func setMessageView(for message: Message, isIncoming: Bool, in view: UIView) {
        let textColor = isIncoming ? SwiftyCore.UI.Chat.incomingTextColor : SwiftyCore.UI.Chat.outgoingTextColor
        if message.type == .text {
            let textMessageView = TextMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(textMessageView)
            textMessageView.set(with: message.message ?? "", color: textColor, font: SwiftyCore.UI.Chat.messageFont)
        } else if message.type == .image {
            let imageMessageView = ImageMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(imageMessageView)
            guard let url = message.assetUrl else { return }
            imageMessageView.set(image: url, requestHeaders: message.assetUrlRequestHeaders, delegate: self)
        } else if message.type == .voice {
            let voiceMessageView = VoiceMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(voiceMessageView)
            guard let url = message.assetUrl else { return }
            voiceMessageView.set(with: url, assetUrlRequestHeaders: message.assetUrlRequestHeaders, and: message.id,
                                 type: SwiftyCore.UI.Chat.voiceMessageProgressBarStyle, isIncoming: isIncoming)
        }
    }
    
    func createAvatar(for message: Message, isIncoming: Bool, in rect: CGRect) -> SwiftyCore.UI.AvatarView {
        let placeholderBackColors = isIncoming ? SwiftyCore.UI.Chat.incomingAvatarPlaceholderBackColors : SwiftyCore.UI.Chat.outgoingAvatarPlaceholderBackColors
        let placeholderImage = SwiftyCore.UI.Chat.useInitialsForAvatarPlaceholder ?
            SwiftyCore.UI.Chat.createAvatarPlaceholder(in: rect, for: message.user?.name ?? "", font: SwiftyCore.UI.Chat.avatarPlaceholderFont, backgroundColors: placeholderBackColors) :
            SwiftyCore.UI.Chat.avatarPlaceholderImage
        return SwiftyCore.UI.AvatarView(rect: rect, backColor: SwiftyCore.UI.Chat.avatarBackColor, cornerRadius: SwiftyCore.UI.Chat.avatarCornerRadius, placeholderImage: placeholderImage)
    }
    
    func setAvatar(in view: UIView, isIncoming: Bool) {
        guard let message = message else { return }
        avatar = createAvatar(for: message, isIncoming: isIncoming, in: view.bounds)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped)))
        if let avatar = avatar {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            view.addSubview(avatar.view)
            avatar.set(image: message.user?.avatar?.absoluteString ?? "")
        }
    }
    
    func resetAvatarIfDimensionChanged(view: UIView?, isIncoming: Bool) {
        guard let avatarBackView = view else { return }
        if let currentSize = currentAvatarSize {
            guard currentSize != avatarBackView.bounds.size else { return }
            setAvatar(in: avatarBackView, isIncoming: isIncoming)
        } else {
            setAvatar(in: avatarBackView, isIncoming: isIncoming)
        }
        currentAvatarSize = avatarBackView.bounds.size
    }
    
    func baseMessageCellPrepareForReuse() {
        avatar = nil
    }
    
    func stopPlayingRecording(view: UIView) {
        guard message?.type == .voice else { return }
        for subview in view.subviews where subview is VoiceMessageView {
            guard let voiceView = subview as? VoiceMessageView else { continue }
            voiceView.stopPlayingRecording()
        }
    }
}

extension BaseMessageCell: ImageMessageViewDelegate {
    func didTapImage(with url: String) {
        messageCellDelegate?.didTapOnImageMessage(with: url)
    }
}

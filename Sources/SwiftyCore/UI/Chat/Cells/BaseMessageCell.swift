//
//  BaseMessageCell.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

class BaseMessageCell: UITableViewCell {
    var message: SwiftyCore.UI.Chat.Message?
    var avatar: SwiftyCore.UI.AvatarView?
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = SwiftyCore.UI.Chat.timstampDateFormat
        return formatter
    }
    
    func getTimestampString(from message: SwiftyCore.UI.Chat.Message) -> String {
        if let dateString = message.timestampString {
            return dateString
        } else if let date = message.timestamp {
            return dateFormatter.string(from: date)
        } else {
            return "no timestamp"
        }
    }
    
    func setMessageView(for message: SwiftyCore.UI.Chat.Message, isIncoming: Bool, in view: UIView) {
        let textColor = isIncoming ? SwiftyCore.UI.Chat.incomingTextColor : SwiftyCore.UI.Chat.outgoingTextColor
        if message.type == .text {
            let textMessageView = TextMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(textMessageView)
            textMessageView.set(with: message.message ?? "", color: textColor, font: SwiftyCore.UI.Chat.messageFont)
        } else if message.type == .image {
            let imageMessageView = ImageMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(imageMessageView)
            guard let url = message.assetUrl else { return }
            imageMessageView.set(image: url)
        } else if message.type == .voice {
            let voiceMessageView = VoiceMessageView.instanceFromNib(with: view.bounds)
            view.addSubview(voiceMessageView)
            guard let url = message.assetUrl else { return }
            voiceMessageView.set(with: url, and: message.id, type: .waveform)
        }
    }
    
    func createAvatar(for message: SwiftyCore.UI.Chat.Message, isIncoming: Bool, in rect: CGRect) -> SwiftyCore.UI.AvatarView {
        let placeholderBackColors = isIncoming ? SwiftyCore.UI.Chat.incomingAvatarPlaceholderBackColors : SwiftyCore.UI.Chat.outgoingAvatarPlaceholderBackColors
        let placeholderImage = SwiftyCore.UI.Chat.useInitialsForAvatarPlaceholder ?
            SwiftyCore.UI.Chat.createAvatarPlaceholder(in: rect, for: message.user?.name ?? "", backgroundColors: placeholderBackColors) :
            UIImage(named: "avatarPlaceholder")!
        return SwiftyCore.UI.AvatarView(rect: rect, backColor: SwiftyCore.UI.Chat.avatarBackColor, cornerRadius: SwiftyCore.UI.Chat.avatarCornerRadius, placeholderImage: placeholderImage)
    }
    
    func setAvatar(in view: UIView, isIncoming: Bool) {
        guard let message = message else { return }
        avatar = createAvatar(for: message, isIncoming: isIncoming, in: view.bounds)
        if let avatar = avatar {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            view.addSubview(avatar.view)
            avatar.set(image: message.user?.avatar?.absoluteString ?? "")
        }
    }
    
    func baseMessageCellPrepareForReuse() {
        avatar = nil
    }
}

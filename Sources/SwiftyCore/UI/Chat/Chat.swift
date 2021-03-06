//
//  File.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    public struct Chat {
        public static var incomingBubbleColor: UIColor = .red
        public static var incomingBubbleBorderColor: UIColor = .red
        public static var outgoingBubbleColor: UIColor = .green
        public static var outgoingBubbleBorderColor: UIColor = .green
        public static var bubbleCornerRadius: CGFloat = 10
        public static var incomingTextColor: UIColor = .black
        public static var outgoingTextColor: UIColor = .black
        public static var messageFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var timestampTextColor: UIColor = .lightGray
        public static var timestampFont: UIFont = UIFont.systemFont(ofSize: 10)
        public static var timstampDateFormat: String = "HH:mm"
        
        public static var bubbleStyle: BubbleStyle = .normal
        public static var timestampInsideBubble: Bool = true
        
        public static var avatarAllignTopBubble: Bool = false
        public static var avatarWidth: CGFloat = 50
        public static var avatarCornerRadius: CGFloat = 25
        public static var avatarBackColor: UIColor = .clear
        public static var incomingAvatarShown: Bool = true
        public static var outgoingAvatarShown: Bool = true
        
        public static var useInitialsForAvatarPlaceholder: Bool = true
        public static var avatarPlaceholderFont: UIFont?
        public static var incomingAvatarPlaceholderBackColors: [UIColor] = [.lightGray]
        public static var outgoingAvatarPlaceholderBackColors: [UIColor] = [.lightGray]
        public static var avatarPlaceholderImage: UIImage = Image.avatarPlaceholder.uiImage
        
        public static var voiceMessagesSupported: Bool = true
        public static var imageMessagesSupported: Bool = true
        
        public static var voiceButtonIcon: UIImage = Image.voice.uiImage.withRenderingMode(.alwaysOriginal)
        public static var sendActiveIcon: UIImage = Image.chatSend.uiImage.withRenderingMode(.alwaysOriginal)
        public static var sendInactiveIcon: UIImage = Image.chatSend.uiImage.withRenderingMode(.alwaysOriginal)
        public static var addImageIcon: UIImage = Image.photo.uiImage.withRenderingMode(.alwaysOriginal)
        
        public static var inputMessageFont: UIFont = UIFont.systemFont(ofSize: 16)
        public static var inputMessagePlaceholder: String = "Type a message..."
        public static var inputMessagePlaceholderColor: UIColor = .lightGray
        public static var inputMessageTextColor: UIColor = .black
        public static var inputFieldBorderColor: UIColor = .lightGray
    }
}

extension SwiftyCore.UI.Chat {
    public static func createAvatarPlaceholder(in frame: CGRect,
                                               for name: String,
                                               textColor: UIColor = .white,
                                               font: UIFont? = nil,
                                               backgroundColors: [UIColor] = [.lightGray]) -> UIImage {
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = backgroundColors.randomElement()
        nameLabel.textColor = textColor
        nameLabel.font = font ?? UIFont.boldSystemFont(ofSize: 20)
        let initialsArray: [String] = name.components(separatedBy: " ").compactMap({ (string: String) in
            guard let first = string.first else { return nil }
            return String(first)
        })
        nameLabel.text = String(initialsArray.joined().prefix(2).uppercased())
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            guard let nameImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
            return nameImage
        } else {
            return UIImage()
        }
    }
}

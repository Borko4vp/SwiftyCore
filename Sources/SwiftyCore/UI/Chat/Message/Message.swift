//
//  Message.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation

extension SwiftyCore.UI.Chat {
    public struct Message {
        let id: String = "message_ID"
        let type: SwiftyCore.UI.Chat.MessageType
        let timestampString: String?
        let timestamp: Date?
        let message: String?
        let assetUrl: URL?
        let user: MessageUser?
        
        public init(type: SwiftyCore.UI.Chat.MessageType, timestamp: Date? = nil, timestampString: String? = nil, message: String? = nil, asset: URL? = nil, userName: String, avatarUrl: String? = nil) {
            self.type = type
            self.message = message
            self.timestamp = timestamp
            self.timestampString = timestampString
            assetUrl = asset
            user = MessageUser(name: userName, avatar: URL(string: avatarUrl ?? ""))
        }
    }
}


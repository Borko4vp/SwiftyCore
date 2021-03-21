//
//  Message.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation

extension SwiftyCore.UI.Chat {
    public struct Message {
        let id: String
        let type: SwiftyCore.UI.Chat.MessageType
        let timestampString: String?
        let timestamp: Date?
        let message: String?
        let assetUrl: URL?
        public let user: MessageUser?
        
        let assetUrlRequestHeaders: [String: String]?
        
        
        public init(type: SwiftyCore.UI.Chat.MessageType, messageId: String = "message_ID", timestamp: Date? = nil, timestampString: String? = nil, message: String? = nil, asset: URL? = nil, assetUrlRequestHeaders: [String: String]? = nil, userName: String, avatarUrl: String? = nil, userId: String? = nil) {
            self.id = messageId
            self.type = type
            self.message = message
            self.timestamp = timestamp
            self.timestampString = timestampString
            assetUrl = asset
            self.assetUrlRequestHeaders = assetUrlRequestHeaders
            user = MessageUser(id: userId ?? "", name: userName, avatar: URL(string: avatarUrl ?? ""))
        }
    }
}


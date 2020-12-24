//
//  File.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation

extension SwiftyCore.UI.Chat {
    public struct Message {
        let type: SwiftyCore.UI.Chat.MessageType
        let timestampString: String?
        let timestamp: Date?
        let message: String?
        let assetUrl: URL?
        let user: MessageUser?
        
        public init(type: SwiftyCore.UI.Chat.MessageType, message: String? = nil, asset: URL? = nil) {
            self.type = type
            self.message = message
            timestampString = nil
            timestamp = nil
            assetUrl = asset
            user = nil
        }
    }
}


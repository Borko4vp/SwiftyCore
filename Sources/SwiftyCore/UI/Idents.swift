//
//  File.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    public struct Cells {
        public struct Nibs {
            public static var incomingMessageCell = UINib(nibName: "IncomingMessageCell", bundle: Bundle.module)
            public static let outgoingMessageCell = UINib(nibName: "OutgoingMessageCell", bundle: Bundle.module)
        }
        
        public struct Idents {
            public static let incomingMessageCell = "IncomingMessageCellIdent"
            public static let outgoingMessageCell = "OutgoingMessageCellIdent"
        }
    }
    
    struct InternalViews {
        struct Nibs {
            static var progressViewInternal = UINib(nibName: "ProgressViewInternal", bundle: Bundle.module)
            static var avatarViewInternal = UINib(nibName: "AvatarViewInternal", bundle: Bundle.module)
            
            static var imageMessageView = UINib(nibName: "ImageMessageView", bundle: Bundle.module)
            static var voiceMessageView = UINib(nibName: "VoiceMessageView", bundle: Bundle.module)
            static var textMessageView = UINib(nibName: "TextMessageView", bundle: Bundle.module)
            
            static var inputMessageView = UINib(nibName: "InputMessageView", bundle: Bundle.module)
        }
        
        struct Idents {
            
        }
    }
}


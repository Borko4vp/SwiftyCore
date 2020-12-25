//
//  File.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    public struct Views {
        public struct Nibs {
            public static var progressView = UINib(nibName: "ProgressView", bundle: Bundle.module)
        }
    }
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
            static var imageMessageView = UINib(nibName: "ImageMessageView", bundle: Bundle.module)
            static var voiceMessageView = UINib(nibName: "VoiceMessageView", bundle: Bundle.module)
            static var textMessageView = UINib(nibName: "TextMessageView", bundle: Bundle.module)
        }
        
        struct Idents {
            public static let imageMessageView = "ImageMessageViewIdent"
        }
    }
}


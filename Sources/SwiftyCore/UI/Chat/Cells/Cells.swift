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
            static var imageMessageView = UINib(nibName: "ImageMessageView", bundle: Bundle.module)
        }
        
        struct Idents {
            public static let imageMessageView = "ImageMessageViewIdent"
        }
    }
}


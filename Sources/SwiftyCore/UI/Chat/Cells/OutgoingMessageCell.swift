//
//  OutgoingMessageCell.swift
//  iVault
//
//  Created by Borko Tomic on 17.12.20..
//

import UIKit

class OutgoingMessageCell: UITableViewCell {

    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var avatarBackView: UIView!
    @IBOutlet private weak var bubbleView: UIView!
    
    @IBOutlet private weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messagePrepareForReuse()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // invoke draw from MessageCell protocol
        messageDraw(on: rect)
    }
}

extension OutgoingMessageCell: MessageCell {
    var messagePlaceholderView: UIView { return messageView }
    var cornerRadius: CGFloat { SwiftyCore.UI.Chat.cornerRadius }
    var borderColor: UIColor { SwiftyCore.UI.Chat.outgoingBuggleBorderColor }
    var bubbleColor: UIColor { SwiftyCore.UI.Chat.outgoingBuggleColor }
    
    func set(with message: SwiftyCore.UI.Chat.Message) {
        if message.type == .text {
            let textMessageView = TextMessageView.instanceFromNib(with: messagePlaceholderView.bounds)
            messagePlaceholderView.addSubview(textMessageView)
            textMessageView.set(with: message.message ?? "", color: SwiftyCore.UI.Chat.outgoingTextColor)
        } else if message.type == .image {
            let imageMessageView = ImageMessageView.instanceFromNib(with: messagePlaceholderView.bounds)
            messagePlaceholderView.addSubview(imageMessageView)
            guard let url = message.assetUrl else { return }
            imageMessageView.set(image: url)
        }
    }
    
    func getBubblePath() -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.minY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.maxY - cornerRadius))
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius,
                                              y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(),
                          endAngle: CGFloat(Double.pi/2),
                          clockwise: true)
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius,
                                              y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi/2),
                          endAngle: CGFloat(Double.pi),
                          clockwise: true)
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius,
                                              y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi),
                          endAngle: CGFloat(3*Double.pi/2),
                          clockwise: true)
        

        
        bezierPath.close()
        return bezierPath
    }
}

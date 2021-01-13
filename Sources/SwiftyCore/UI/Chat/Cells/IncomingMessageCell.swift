//
//  IncomingMessageCell.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 17.12.20..
//

import UIKit

class IncomingMessageCell: UITableViewCell {
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var avatarBackView: UIView!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var bubbleViewFromMessageViewLeadingCst: NSLayoutConstraint!
    
    @IBOutlet private weak var avatarTopBubbleTopAllignCst: NSLayoutConstraint!
    @IBOutlet private weak var avatarBottomBubbleBottomAllignCst: NSLayoutConstraint!
    @IBOutlet private weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
        bubbleViewFromMessageViewLeadingCst.constant = bubbleStyle == .iMessage ? 12 : 8
        avatarTopBubbleTopAllignCst.isActive = bubbleStyle == .normal
        avatarBottomBubbleBottomAllignCst.isActive = bubbleStyle == .iMessage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messagePrepareForReuse()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // invoke draw from MessageCell protocol
        messageDraw(on: rect)
    }
}

extension IncomingMessageCell: MessageCell {
    var messagePlaceholderView: UIView { return messageView }
    var cornerRadius: CGFloat { SwiftyCore.UI.Chat.cornerRadius }
    var borderColor: UIColor { SwiftyCore.UI.Chat.incomingBubbleBorderColor }
    var bubbleColor: UIColor { SwiftyCore.UI.Chat.incomingBubbleColor }
    var bubbleStyle: BubbleStyle { return SwiftyCore.UI.Chat.bubbleStyle }
    
    func set(with message: SwiftyCore.UI.Chat.Message) {
        if message.type == .text {
            let textMessageView = TextMessageView.instanceFromNib(with: messagePlaceholderView.bounds)
            messagePlaceholderView.addSubview(textMessageView)
            textMessageView.set(with: message.message ?? "", color: SwiftyCore.UI.Chat.incomingTextColor)
        } else if message.type == .image {
            let imageMessageView = ImageMessageView.instanceFromNib(with: messagePlaceholderView.bounds)
            messagePlaceholderView.addSubview(imageMessageView)
            guard let url = message.assetUrl else { return }
            imageMessageView.set(image: url)
        } else if message.type == .voice {
            let voiceMessageView = VoiceMessageView.instanceFromNib(with: messagePlaceholderView.bounds)
            messagePlaceholderView.addSubview(voiceMessageView)
            guard let url = message.assetUrl else { return }
            voiceMessageView.set(with: url, and: message.id, type: .waveform)
        }
        setNeedsLayout()
    }
    
    func getBubblePath() -> UIBezierPath {
        switch bubbleStyle {
        case .normal: return getNormalBubble()
        case .iMessage: return getiMessageBubble()
        }
    }
}

// Bubble paths
extension IncomingMessageCell {
    private func getiMessageBubble() -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.minX + 22, y: bubbleViewRect.maxY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX - cornerRadius, y: bubbleViewRect.maxY))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius, y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi/2),
                          endAngle: CGFloat(0),
                          clockwise: false)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.minY + cornerRadius))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius, y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(0),
                          endAngle: CGFloat(-Double.pi/2),
                          clockwise: false)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX + cornerRadius+4, y: bubbleViewRect.minY))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius+4, y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(3*Double.pi/2),
                          endAngle: CGFloat(Double.pi),
                          clockwise: false)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX+4, y: bubbleViewRect.maxY - 11))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.maxY),
                            controlPoint1: CGPoint(x: bubbleViewRect.minX+4, y: bubbleViewRect.maxY - 1),
                            controlPoint2: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.maxY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX-0.05, y: bubbleViewRect.maxY-0.01))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.minX+11.04, y: bubbleViewRect.maxY-4.04),
                            controlPoint1: CGPoint(x: bubbleViewRect.minX+4.07, y: bubbleViewRect.maxY + 0.43),
                            controlPoint2: CGPoint(x: bubbleViewRect.minX+8.16, y: bubbleViewRect.maxY - 1.06))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.minX+22, y: bubbleViewRect.maxY),
                            controlPoint1: CGPoint(x: bubbleViewRect.minX+16, y: bubbleViewRect.maxY),
                            controlPoint2: CGPoint(x: bubbleViewRect.minX+19, y: bubbleViewRect.maxY))
        bezierPath.close()
        return bezierPath
    }
    
    private func getNormalBubble() -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.minY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX - cornerRadius, y: bubbleViewRect.minY))
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius,
                                              y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(3*Double.pi/2),
                          endAngle: CGFloat(2*Double.pi),
                          clockwise: true)
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius,
                                              y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle:  CGFloat(),
                          endAngle: CGFloat(Double.pi/2),
                          clockwise: true)
        
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius,
                                              y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi/2),
                          endAngle: CGFloat(Double.pi),
                          clockwise: true)
        
        bezierPath.close()
        return bezierPath
    }
}

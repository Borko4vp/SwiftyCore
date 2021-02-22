//
//  IncomingMessageCell.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 17.12.20..
//

import UIKit

class IncomingMessageCell: BaseMessageCell {
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var insideTimestampLabel: UILabel!
    @IBOutlet private weak var avatarBackView: UIView!
    @IBOutlet private weak var avatarViewWidthCst: NSLayoutConstraint!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var bubbleViewFromMessageViewLeadingCst: NSLayoutConstraint!
    
    @IBOutlet private weak var avatarTopBubbleTopAllignCst: NSLayoutConstraint!
    @IBOutlet private weak var avatarBottomBubbleBottomAllignCst: NSLayoutConstraint!
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var bubbleViewTopCst: NSLayoutConstraint!
    @IBOutlet private weak var messageViewBottomCst: NSLayoutConstraint!
    @IBOutlet private weak var bubbleViewLeadingCst: NSLayoutConstraint!
    @IBOutlet private weak var insideTimstampLabelLeadingCst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
        insideTimestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
        timestampLabel.font = SwiftyCore.UI.Chat.timestampFont.withSize(10)
        insideTimestampLabel.font = SwiftyCore.UI.Chat.timestampFont.withSize(10)
        bubbleViewFromMessageViewLeadingCst.constant = bubbleStyle == .iMessage ? 12 : 8
        avatarTopBubbleTopAllignCst.isActive = SwiftyCore.UI.Chat.avatarAllignTopBubble
        avatarBottomBubbleBottomAllignCst.isActive = !SwiftyCore.UI.Chat.avatarAllignTopBubble
        bubbleViewTopCst.constant = SwiftyCore.UI.Chat.timestampInsideBubble ? 8 : 22
        messageViewBottomCst.constant = SwiftyCore.UI.Chat.timestampInsideBubble ? 18 : 4
        timestampLabel.isHidden = SwiftyCore.UI.Chat.timestampInsideBubble
        insideTimestampLabel.isHidden = !SwiftyCore.UI.Chat.timestampInsideBubble
        insideTimstampLabelLeadingCst.constant = bubbleStyle == .iMessage ? 12 : 4
        avatarBackView.isHidden = !SwiftyCore.UI.Chat.incomingAvatarShown
        bubbleViewLeadingCst.constant = SwiftyCore.UI.Chat.incomingAvatarShown ? (SwiftyCore.UI.Chat.avatarWidth + 16) : 8
        avatarViewWidthCst.constant = SwiftyCore.UI.Chat.avatarWidth
        avatarBackView.layer.cornerRadius = SwiftyCore.UI.Chat.avatarCornerRadius
        avatarBackView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messagePrepareForReuse()
        baseMessageCellPrepareForReuse()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // invoke draw from MessageCell protocol
        messageDraw(on: rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        resetAvatarIfDimensionChanged(view: avatarBackView, isIncoming: true)
    }
    
    override func avatarTapped() {
        messageCellDelegate?.didTapOnAvatar(with: message?.user?.avatar?.absoluteString)
    }
    
    @IBAction private func backgroundButtonAction(_ sender: UIButton) {
        guard let message = message else { return }
        messageCellDelegate?.didTapOnCellBackground(with: message)
    }
}

extension IncomingMessageCell: MessageCell {
    var messagePlaceholderView: UIView { return messageView }
    var cornerRadius: CGFloat { SwiftyCore.UI.Chat.bubbleCornerRadius }
    var borderColor: UIColor { SwiftyCore.UI.Chat.incomingBubbleBorderColor }
    var bubbleColor: UIColor { SwiftyCore.UI.Chat.incomingBubbleColor }
    var bubbleStyle: BubbleStyle { return SwiftyCore.UI.Chat.bubbleStyle }
    
    func set(with message: Message, delegate: MessageCellDelegate) {
        self.message = message
        self.messageCellDelegate = delegate
        setMessageView(for: message, isIncoming: true, in: messagePlaceholderView)
        timestampLabel.text = getTimestampString(from: message)
        insideTimestampLabel.text = getTimestampString(from: message)
        guard let avatarBackView = avatarBackView else { return }
        setAvatar(in: avatarBackView, isIncoming: true)
        setNeedsLayout()
    }
    
    func getBubblePath() -> UIBezierPath {
        switch bubbleStyle {
        case .normal: return getNormalBubble(avatarTop: SwiftyCore.UI.Chat.avatarAllignTopBubble)
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
    
    private func getNormalBubble(avatarTop: Bool) -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.minX + (avatarTop ? 0 : cornerRadius), y: bubbleViewRect.minY))
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
        if avatarTop {
            bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius,
                                                  y: bubbleViewRect.maxY - cornerRadius),
                              radius: cornerRadius,
                              startAngle: CGFloat(Double.pi/2),
                              endAngle: CGFloat(Double.pi),
                              clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.maxY))
            bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.minY + cornerRadius))
            bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius,
                                                  y: bubbleViewRect.minY + cornerRadius),
                              radius: cornerRadius,
                              startAngle: CGFloat(Double.pi),
                              endAngle: CGFloat(3*Double.pi/2),
                              clockwise: true)
            
        }
        bezierPath.close()
        return bezierPath
    }
}

//
//  OutgoingMessageCell.swift
//  SwiftyCore
//
//  Created by Borko Tomic on 17.12.20..
//

import UIKit

class OutgoingMessageCell: BaseMessageCell {

    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var insideTimestampLabel: UILabel!
    @IBOutlet private weak var avatarBackView: UIView!
    @IBOutlet private weak var avatarViewWidthCst: NSLayoutConstraint!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var bubbleViewFromMessageViewTrailingCst: NSLayoutConstraint!
    @IBOutlet private weak var avatarTopBubbleTopAllignCst: NSLayoutConstraint!
    @IBOutlet private weak var avatarBottomBubbleBottomAllignCst: NSLayoutConstraint!
    
    @IBOutlet private weak var messageView: UIView!
    
    @IBOutlet private weak var bubbleViewTopCst: NSLayoutConstraint!
    @IBOutlet private weak var messageViewBottomCst: NSLayoutConstraint!
    @IBOutlet private weak var bubbleViewTrailingCst: NSLayoutConstraint!
    @IBOutlet private weak var insideTimestampLabelTrailingCst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
        insideTimestampLabel.textColor = SwiftyCore.UI.Chat.timestampTextColor
        timestampLabel.font = SwiftyCore.UI.Chat.timestampFont.withSize(10)
        insideTimestampLabel.font = SwiftyCore.UI.Chat.timestampFont.withSize(10)
        bubbleViewFromMessageViewTrailingCst.constant = bubbleStyle == .iMessage ? 12 : 8
        avatarTopBubbleTopAllignCst.isActive = SwiftyCore.UI.Chat.avatarAllignTopBubble
        avatarBottomBubbleBottomAllignCst.isActive = !SwiftyCore.UI.Chat.avatarAllignTopBubble
        bubbleViewTopCst.constant = SwiftyCore.UI.Chat.timestampInsideBubble ? 8 : 22
        messageViewBottomCst.constant = SwiftyCore.UI.Chat.timestampInsideBubble ? 18 : 4
        timestampLabel.isHidden = SwiftyCore.UI.Chat.timestampInsideBubble
        insideTimestampLabel.isHidden = !SwiftyCore.UI.Chat.timestampInsideBubble
        avatarViewWidthCst.constant = SwiftyCore.UI.Chat.avatarWidth
        insideTimestampLabelTrailingCst.constant = bubbleStyle == .iMessage ? 12 : 4
        avatarBackView.isHidden = !SwiftyCore.UI.Chat.outgoingAvatarShown
        bubbleViewTrailingCst.constant = SwiftyCore.UI.Chat.outgoingAvatarShown ? (SwiftyCore.UI.Chat.avatarWidth + 16) : 8
        avatarBackView.layer.cornerRadius = SwiftyCore.UI.Chat.avatarCornerRadius
        avatarBackView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messagePrepareForReuse()
        baseMessageCellPrepareForReuse()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // invoke draw from MessageCell protocol
        messageDraw(on: rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        resetAvatarIfDimensionChanged(view: avatarBackView, isIncoming: false)
    }
    
    override func avatarTapped() {
        messageCellDelegate?.didTapOnAvatar(with: message?.user?.avatar?.absoluteString)
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        guard let message = message else { return }
        messageCellDelegate?.didTapOnCellBackground(with: message)
    }
}

extension OutgoingMessageCell: MessageCell {
    var messagePlaceholderView: UIView { return messageView }
    var cornerRadius: CGFloat { SwiftyCore.UI.Chat.bubbleCornerRadius }
    var borderColor: UIColor { SwiftyCore.UI.Chat.outgoingBubbleBorderColor }
    var bubbleColor: UIColor { SwiftyCore.UI.Chat.outgoingBubbleColor }
    var bubbleStyle: BubbleStyle { return SwiftyCore.UI.Chat.bubbleStyle }
    
    func set(with message: Message, delegate: MessageCellDelegate) {
        self.message = message
        self.messageCellDelegate = delegate
        setMessageView(for: message, isIncoming: false, in: messagePlaceholderView)
        timestampLabel.text = getTimestampString(from: message)
        insideTimestampLabel.text = getTimestampString(from: message)
//        guard let avatarBackView = avatarBackView else { return }
//        setAvatar(in: avatarBackView, isIncoming: true)
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
extension OutgoingMessageCell {
    private func getNormalBubble(avatarTop: Bool) -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.minY + (avatarTop ? 0 : cornerRadius)))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.maxY - cornerRadius))
        
        if avatarTop {
            bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius,
                                                  y: bubbleViewRect.maxY - cornerRadius),
                              radius: cornerRadius,
                              startAngle: CGFloat(),
                              endAngle: CGFloat(Double.pi/2),
                              clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.maxY))
            bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX + cornerRadius, y: bubbleViewRect.maxY))
        }

        
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
        if !avatarTop {
            bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX - cornerRadius, y: bubbleViewRect.minY))
            bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius,
                                                  y: bubbleViewRect.minY + cornerRadius),
                              radius: cornerRadius,
                              startAngle: CGFloat(3*Double.pi/2),
                              endAngle: CGFloat(2*Double.pi),
                              clockwise: true)
        }
        bezierPath.close()
        return bezierPath
    }
    
    private func getiMessageBubble() -> UIBezierPath {
        let bubbleViewRect = bubbleView.frame
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bubbleViewRect.maxX - 22, y: bubbleViewRect.maxY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX + cornerRadius, y: bubbleViewRect.maxY))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius, y: bubbleViewRect.maxY - cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi/2),
                          endAngle: CGFloat(Double.pi),
                          clockwise: true)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.minX, y: bubbleViewRect.minY + cornerRadius))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.minX + cornerRadius, y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(Double.pi),
                          endAngle: CGFloat(3*Double.pi/2),
                          clockwise: true)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX - cornerRadius-4, y: bubbleViewRect.minY))
        bezierPath.addArc(withCenter: CGPoint(x: bubbleViewRect.maxX - cornerRadius-4, y: bubbleViewRect.minY + cornerRadius),
                          radius: cornerRadius,
                          startAngle: CGFloat(3*Double.pi/2),
                          endAngle: CGFloat(2*Double.pi),
                          clockwise: true)
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX - 4, y: bubbleViewRect.maxY - 11))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.maxY),
                            controlPoint1: CGPoint(x: bubbleViewRect.maxX - 4, y: bubbleViewRect.maxY - 1),
                            controlPoint2: CGPoint(x: bubbleViewRect.maxX, y: bubbleViewRect.maxY))
        bezierPath.addLine(to: CGPoint(x: bubbleViewRect.maxX + 0.05, y: bubbleViewRect.maxY - 0.01))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.maxX - 11.04, y: bubbleViewRect.maxY - 4.04),
                            controlPoint1: CGPoint(x: bubbleViewRect.maxX - 4.07, y: bubbleViewRect.maxY + 0.43),
                            controlPoint2: CGPoint(x: bubbleViewRect.maxX - 8.16, y: bubbleViewRect.maxY - 1.06))
        bezierPath.addCurve(to: CGPoint(x: bubbleViewRect.maxX - 22, y: bubbleViewRect.maxY),
                            controlPoint1: CGPoint(x: bubbleViewRect.maxX - 16, y: bubbleViewRect.maxY),
                            controlPoint2: CGPoint(x: bubbleViewRect.maxX - 19, y: bubbleViewRect.maxY))
        bezierPath.close()
        return bezierPath
    }
}

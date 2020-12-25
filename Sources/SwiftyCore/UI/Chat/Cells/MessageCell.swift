//
//  MessageCell.swift
//  
//
//  Created by Borko Tomic on 17.12.20..
//

import Foundation
import UIKit

public protocol MessageCell where Self: UITableViewCell {
    
    var cornerRadius: CGFloat { get }
    var borderColor: UIColor { get }
    var bubbleColor: UIColor { get }
    
    var messagePlaceholderView: UIView { get }
    
    func set(with message: SwiftyCore.UI.Chat.Message)
    func getBubblePath() -> UIBezierPath
}

public extension MessageCell {
    func messageDraw(on rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = getBubblePath().cgPath
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.fillColor = bubbleColor.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = .zero
        shapeLayer.name = "borderPathLayer"
        for layer in self.layer.sublayers ?? [] where layer.name == "borderPathLayer" {
            layer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func messagePrepareForReuse() {
        //messagePlaceholderView.frame = .zero
        for subview in messagePlaceholderView.subviews {
            subview.removeFromSuperview()
        }
    }
}

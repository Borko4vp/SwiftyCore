//
//  Toastable.swift
//  CommonCore
//
//  Created by Borko Tomic on 20/11/2020.
//

import Foundation
import UIKit

public enum ToastPosition {
    case up
    case down
}

extension SwiftyCore.UI {
    public struct Toast {
        public static var position: ToastPosition = .up
        public static var height: CGFloat = 120
        public static var imageHeight: CGFloat = 30
        public static var animationDuration: Double = 0.25
        public static var toastDuration: CGFloat = 4
        public static var offset: CGFloat = 0
        public static var cornerRadius: CGFloat = 0
        public static var alpha: CGFloat = 1
        public static var color: UIColor = .black
        public static var textColor: UIColor = .white
        public static var font: UIFont = UIFont.systemFont(ofSize: 16)
        public static var fontSize: CGFloat = 16
    }
}

public protocol Toastaable where Self: UIViewController {
    func showToast(text: String, image: UIImage?, durationInSeconds: Int, color: UIColor, textColor: UIColor, completion: (() -> Void)?)
}

public extension Toastaable {
    func showToast(text: String, image: UIImage?, durationInSeconds: Int = 4, color: UIColor = SwiftyCore.UI.Toast.color, textColor: UIColor = SwiftyCore.UI.Toast.textColor, completion: (() -> Void)? = nil ) {
        DispatchQueue.main.async {
            let toastView = self.createToastView(image: image, backgroundColor: color.withAlphaComponent(SwiftyCore.UI.Toast.alpha), text: text, textColor: textColor)
            if let view = self.navigationController?.view {
                view.addSubview(toastView)
            } else {
                self.view.addSubview(toastView)
            }
            UIView.animate(withDuration: self.toastAnimationDuration, delay: 0.0, options: .curveLinear) {
                toastView.frame = self.getEndingFrame()
            }
            guard durationInSeconds > 0 else { return }
            let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(durationInSeconds), repeats: false) { _ in
                UIView.animate(withDuration: self.toastAnimationDuration, delay: 0.0, options: .curveLinear, animations: {
                    toastView.frame = self.getStartingFrame()
                }) { completed in
                    toastView.removeFromSuperview()
                    completion?()
                }
            }
        }
    }
    
    private func getStartingFrame() -> CGRect {
        let originY = position == .down ? view.bounds.height : -toastHeight
        let origin = CGPoint(x: offset, y: originY)
        return CGRect(origin: origin, size: size)
    }
    
    private func getEndingFrame() -> CGRect {
        let safeAreaInset = position == .up ? UIDevice.safeAreaInsets.top : UIDevice.safeAreaInsets.bottom
        let totalOffset = offset  +  (offset == 0 ? 0 : safeAreaInset)
        let originY = position == .down ? view.bounds.height-totalOffset-toastHeight : totalOffset
        let origin = CGPoint(x: offset, y: originY)
        return CGRect(origin: origin, size: size)
    }
    
    private func createToastView(image: UIImage?, backgroundColor: UIColor, text: String, textColor: UIColor) -> UIView {
        // adding image view
        let returnView = UIView(frame: getStartingFrame())
        returnView.layer.cornerRadius = cornerRadius
        returnView.backgroundColor = backgroundColor
        let hasImage = image != nil
        let hasOffset = offset > 0
        let theImageView = UIImageView()
        theImageView.image = image?.withRenderingMode(.alwaysTemplate)
        theImageView.tintColor = textColor
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.clipsToBounds = true
        theImageView.contentMode = .scaleAspectFit
        returnView.addSubview(theImageView)
        
        let safeAreaInset = position == .up ? UIDevice.safeAreaInsets.top : UIDevice.safeAreaInsets.bottom
        let labelOriginX = (hasImage ? imageHeight+16+8 : 16)
        let labelOriginY = position == .up ? (hasOffset ? 16 : safeAreaInset+8) : 8
        let labelOriginYBottom = position == .up ? 8 : (hasOffset ? 16 : safeAreaInset+8)
        let labelViewFrame = CGRect(x: labelOriginX,
                                    y: labelOriginY,
                                    width: size.width - labelOriginX - 16,
                                    height: size.height - labelOriginY - labelOriginYBottom)
        let theLabelView = UIView(frame: labelViewFrame)
        returnView.addSubview(theLabelView)
        let theLabel = UILabel()
        theLabel.textColor = textColor
        theLabel.textAlignment = .center
        theLabel.text = text
        theLabel.font = SwiftyCore.UI.Toast.font.withSize(SwiftyCore.UI.Toast.fontSize)
        theLabel.numberOfLines = 0
        theLabel.sizeToFit()
        theLabel.translatesAutoresizingMaskIntoConstraints = false
        theLabelView.addSubview(theLabel)
        
        if hasImage {
            theImageView.widthAnchor.constraint(equalToConstant: imageHeight).isActive = true
            theImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
            theImageView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: 16).isActive = true
            //theImageView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -16).isActive = true
            theLabelView.leadingAnchor.constraint(equalTo: theImageView.trailingAnchor, constant: 8).isActive = true
        } else {
            theLabelView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: 16).isActive = true
        }
        theImageView.centerYAnchor.constraint(equalTo: theLabelView.centerYAnchor, constant: 0).isActive = true
        theLabelView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor, constant: -16).isActive = true
        theLabelView.topAnchor.constraint(equalTo: returnView.topAnchor, constant: labelOriginY).isActive = true
        theLabelView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -labelOriginYBottom).isActive = true
        
        theLabel.leadingAnchor.constraint(equalTo: theLabelView.leadingAnchor, constant: 0).isActive = true
        theLabel.trailingAnchor.constraint(equalTo: theLabelView.trailingAnchor, constant: 0).isActive = true
        theLabel.centerYAnchor.constraint(equalTo: theLabelView.centerYAnchor).isActive = true
        return returnView
    }
    
    private var size: CGSize { CGSize(width: view.bounds.width - 2*offset, height: toastHeight) }
    private var offset: CGFloat { SwiftyCore.UI.Toast.offset }
    private var toastHeight: CGFloat { SwiftyCore.UI.Toast.height }
    private var cornerRadius: CGFloat { SwiftyCore.UI.Toast.cornerRadius }
    private var toastAnimationDuration: Double { SwiftyCore.UI.Toast.animationDuration }
    private var position: ToastPosition { SwiftyCore.UI.Toast.position }
    private var alpha: CGFloat { SwiftyCore.UI.Toast.alpha }
    private var imageHeight: CGFloat { SwiftyCore.UI.Toast.imageHeight }
}

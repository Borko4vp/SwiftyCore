//
//  Toastable.swift
//  CommonCore
//
//  Created by Borko Tomic on 20/11/2020.
//

import Foundation
import UIKit

public protocol Toastaable where Self: UIViewController {
    func showToast(text: String, image: UIImage, durationInSeconds: Int)
}

public extension Toastaable {
    func showToast(text: String, image: UIImage, durationInSeconds: Int = 4) {
        let toastView = createToastView(image: image, backgroundColor: UIColor.black.withAlphaComponent(0.75), text: text, textColor: .white)
        view.addSubview(toastView)
        animate {
            toastView.frame = self.getEndingFrame()
        
        }
        if #available(iOS 10.0, *) {
            let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(durationInSeconds), repeats: false) { _ in
                self.animate(block: {
                    toastView.frame = self.getStartingFrame()
                }) {
                    toastView.removeFromSuperview()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func getStartingFrame() -> CGRect {
        let origin = CGPoint(x: offset, y: view.bounds.height)
        let frame = CGRect(origin: origin, size: size)
        return frame
    }
    
    private func getEndingFrame() -> CGRect {
        let origin = CGPoint(x: offset, y: view.bounds.height-offset-toastHeight)
        let frame = CGRect(origin: origin, size: size)
        return frame
    }
    
    private func createToastView(image: UIImage, backgroundColor: UIColor, text: String, textColor: UIColor) -> UIView {
        // adding image view
        let returnView = UIView(frame: getStartingFrame())
        returnView.layer.cornerRadius = 8.0
        returnView.backgroundColor = backgroundColor
        
        let theImageView = UIImageView()
        theImageView.image = image.withRenderingMode(.alwaysTemplate)
        theImageView.tintColor = textColor
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.clipsToBounds = true
        theImageView.contentMode = .scaleAspectFit
        returnView.addSubview(theImageView)
        theImageView.widthAnchor.constraint(equalToConstant: toastHeight-offset).isActive = true
        theImageView.heightAnchor.constraint(equalToConstant: toastHeight-offset).isActive = true
        theImageView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: offset).isActive = true
        theImageView.topAnchor.constraint(equalTo: returnView.topAnchor, constant: offset/2).isActive = true
        
        let theLabel = UILabel()
        theLabel.textColor = textColor
        theLabel.text = text
        theLabel.font = UIFont.systemFont(ofSize: 12)
        theLabel.numberOfLines = 0
        theLabel.sizeToFit()
        theLabel.translatesAutoresizingMaskIntoConstraints = false
        returnView.addSubview(theLabel)
        
        theLabel.leadingAnchor.constraint(equalTo: theImageView.trailingAnchor, constant: offset).isActive = true
        theLabel.trailingAnchor.constraint(equalTo: returnView.trailingAnchor, constant: -offset).isActive = true
        theLabel.topAnchor.constraint(equalTo: returnView.topAnchor, constant: offset/2).isActive = true
        theLabel.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -offset/2).isActive = true
        
        return returnView
    }
    
    private var size: CGSize { return CGSize(width: view.bounds.width - 2*offset, height: toastHeight) }
    private var offset: CGFloat { return 8.0 }
    private var toastHeight: CGFloat { return 50 }
}

//
//  Toastable.swift
//  CommonCore
//
//  Created by Borko Tomic on 20/11/2020.
//

import Foundation
import UIKit

public protocol Toastaable where Self: UIViewController {
    func showToast(text: String, image: UIImage, durationInSeconds: Int, color: UIColor)
}

public extension Toastaable {
    func showToast(text: String, image: UIImage, durationInSeconds: Int = 4, color: UIColor = UIColor.black.withAlphaComponent(0.75)) {
        DispatchQueue.main.async {
            let toastView = self.createToastView(image: image, backgroundColor: color, text: text, textColor: .white)
            self.view.addSubview(toastView)
            self.animate {
                toastView.frame = self.getEndingFrame()
            }
            guard durationInSeconds > 0 else { return }
            let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(durationInSeconds), repeats: false) { _ in
                self.animate(block: {
                    toastView.frame = self.getStartingFrame()
                }) {
                    toastView.removeFromSuperview()
                }
            }
        }

    }
    
    private func getStartingFrame() -> CGRect {
//        let origin = CGPoint(x: offset, y: view.bounds.height)
//        return CGRect(origin: origin, size: size)
        let origin = CGPoint(x: offset, y: -toastHeight)
        return CGRect(origin: origin, size: size)
        
    }
    
    private func getEndingFrame() -> CGRect {
        let bottomOffset = offset //+ (UIDevice.hasNotch ? 20 : 0)
//        let origin = CGPoint(x: offset, y: view.bounds.height-bottomOffset-toastHeight)
//        return CGRect(origin: origin, size: size)
        
        let origin = CGPoint(x: offset, y: bottomOffset)
        return CGRect(origin: origin, size: size)
    }
    
    private func createToastView(image: UIImage, backgroundColor: UIColor, text: String, textColor: UIColor) -> UIView {
        // adding image view
        let returnView = UIView(frame: getStartingFrame())
        returnView.layer.cornerRadius = cornerRadius
        returnView.backgroundColor = backgroundColor
        
        let theImageView = UIImageView()
        theImageView.image = image.withRenderingMode(.alwaysTemplate)
        theImageView.tintColor = textColor
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.clipsToBounds = true
        theImageView.contentMode = .scaleAspectFit
        returnView.addSubview(theImageView)
        theImageView.widthAnchor.constraint(equalToConstant: toastHeight-2*offset).isActive = true
        theImageView.heightAnchor.constraint(equalToConstant: toastHeight-2*offset).isActive = true
        theImageView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: offset).isActive = true
        theImageView.topAnchor.constraint(equalTo: returnView.topAnchor, constant: offset).isActive = true
        
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
        
        //let cst = returnView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        return returnView
    }
    
    private var size: CGSize { return CGSize(width: view.bounds.width - 2*offset, height: toastHeight) }
    private var offset: CGFloat { return 0.0 }
    private var toastHeight: CGFloat { return 80 }
    private var cornerRadius: CGFloat { return 0.0 }
}

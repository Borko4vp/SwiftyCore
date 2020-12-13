//
//  VCenteredButton.swift
//  
//
//  Created by Borko Tomic on 11.12.20..
//

import UIKit

class VCenteredButton: UIButton {
    var spacing: CGFloat {
        return self.bounds.height/6
    }
    
    var padding: CGFloat = 4
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        return CGRect(x: padding, y: contentRect.height - rect.height - spacing,
                      width: contentRect.width - 2*padding, height: rect.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let imageAspect = rect.height/rect.width
        let titleRect = self.titleRect(forContentRect: contentRect)
        let imageHeight = (contentRect.height - titleRect.height) - 3*spacing
        let imageWidth = imageHeight/imageAspect
        return CGRect(x: contentRect.width/2.0 - imageWidth/2.0,
                      y: spacing,
                      width: imageWidth, height: imageHeight)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0
            
            if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }
            
            return CGSize(width: size.width, height: image.size.height + labelHeight + 8)
        }
        
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
    }
    
    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
    }
}

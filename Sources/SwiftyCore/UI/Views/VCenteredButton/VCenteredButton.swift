//
//  VCenteredButton.swift
//  
//
//  Created by Borko Tomic on 11.12.20..
//

import UIKit

public class VCenteredButton: UIButton {
    public var imageAboveTitle: Bool = true
    
    var spacing: CGFloat { 8 }

    
    var padding: CGFloat { 4 }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let yOrigin = imageAboveTitle ? bounds.height/2 + 2*spacing : spacing
        return CGRect(x: spacing, y: yOrigin,
                      width: contentRect.width - 2*spacing, height: bounds.height/2 - 3*spacing)
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = self.titleRect(forContentRect: contentRect)
        let imageHeight = bounds.height/2
        let imageWidth = contentRect.width - 4*spacing
        let yOrigin = imageAboveTitle ? spacing : titleRect.height + 2*spacing
        return CGRect(x: contentRect.width/2.0 - imageWidth/2.0,
                      y: yOrigin,
                      width: imageWidth, height: imageHeight)
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        guard let image = imageView?.image else { return size }
        var labelHeight: CGFloat = 0.0
        
        if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
            labelHeight = size.height
        }
        
        return CGSize(width: size.width, height: image.size.height + labelHeight + 8)
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
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.imageView?.contentMode = .scaleAspectFit
    }
}

//
//  CollectionViewPagingLayout.swift
//  CollectionViewPagingLayout
//
//  Created by Borko Tomic on 21/06/2020.
//  Copyright © 2017 Borko Tomic. All rights reserved.
//

import UIKit


public class CollectionViewPagingLayout: UICollectionViewFlowLayout {
    override public func prepare() {
        super.prepare()
    }
    //  configuring the content offsets relative to the scroll velocity
    //  Solution provided by orlandoamorim
    var lastPoint: CGPoint = CGPoint.zero
    
    //  configuring the content offsets relative to the scroll velocity
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                             withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layoutAttributes: Array = layoutAttributesForElements(in: collectionView!.bounds)!
        
        if layoutAttributes.count == 0 {
            return proposedContentOffset
        }
        var targetIndex = layoutAttributes.count / 2
        
        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        
        if vX > 0 {
            targetIndex += 1
        } else if vX < 0.0 {
            targetIndex -= 1
        } else if vX == 0 {
            return lastPoint
        }
        
        if targetIndex >= layoutAttributes.count {
            targetIndex = layoutAttributes.count - 1
        }
        
        if targetIndex < 0 {
            targetIndex = 0
        }
        
        let targetAttribute = layoutAttributes[targetIndex]
        
        lastPoint = CGPoint(x: targetAttribute.center.x - collectionView!.bounds.size.width * 0.5, y: proposedContentOffset.y)
        return lastPoint
    }
}

public extension CollectionViewPagingLayout {
    static func updateCellLayoutResizing(for collectionView: UICollectionView) {
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
        for cell in collectionView.visibleCells {
            let offsetX = abs(centerX - cell.center.x)
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (collectionView.bounds.width * 4)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
    static func updateCellLayoutRotating(for collectionView: UICollectionView) {
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
        for cell in collectionView.visibleCells {
            let offsetX = abs(centerX - cell.center.x)
            if offsetX > 0 {
                let offsetPercentage = offsetX / collectionView.bounds.width
                let rotation = 1 - offsetPercentage
                cell.transform = CGAffineTransform(rotationAngle: rotation - 45)
            }
        }
    }
}

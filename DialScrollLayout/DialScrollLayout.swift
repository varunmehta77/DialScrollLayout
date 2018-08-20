//
//  DialScrollLayout.swift
//  DialScrollLayout
//
//  Created by Apple on 20/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

public enum ScrollAlignmentType {
    case Center
    case Left
}

public class DialScrollLayout: UICollectionViewFlowLayout {

    var wheelType: ScrollAlignmentType = .Center
    var cellCount: Int! = 0
    var offset: CGFloat = 0
    var xOffset: CGFloat = 0
    var center: CGPoint = CGPoint.zero
    var dialRadius: CGFloat = 0
    var itemHeight: CGFloat = 0
    var cellSize: CGSize = CGSize.zero
    var angularSpacing: CGFloat = 0
    var currentIndexPath:IndexPath!

    public var changeAlphaWhileScrolling: Bool = true
    public var shouldTransformSize: Bool = true
    public var shouldSnap: Bool = false
    public var isLayoutRightSide: Bool = false

    var lastVelocity: CGPoint = CGPoint.zero

    public init(radius: CGFloat, angularSpacing: CGFloat, cellSize:CGSize, alignment:ScrollAlignmentType, itemHeight:CGFloat, xOffset:CGFloat) {
        super.init()

        self.wheelType = alignment
        self.angularSpacing = angularSpacing
        self.dialRadius = radius
        self.xOffset = xOffset
        self.cellSize = cellSize
        self.itemHeight = itemHeight
        self.itemSize = cellSize

        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.itemHeight = itemHeight
        self.angularSpacing = angularSpacing
        self.sectionInset = UIEdgeInsets.zero
        self.scrollDirection = .vertical
        self.offset = 0.0
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepare() {
        super.prepare()

        if self.collectionView!.numberOfSections > 0 {
            self.cellCount = self.collectionView?.numberOfItems(inSection: 0)
        } else {
            self.cellCount = 0
        }
        self.offset = -self.collectionView!.contentOffset.y / self.itemHeight
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }


    func getRectForItem(_ itemIndex: Int) -> CGRect {
        let newIndex = CGFloat(itemIndex) + self.offset

        let deltaX = self.cellSize.width/2

        let temp = Float(self.angularSpacing)

        let dds = Float(self.dialRadius + (deltaX*1))

        var rX = cosf(temp * Float(newIndex) * Float(Double.pi/180)) * dds

        let rY = sinf(temp * Float(newIndex) * Float(Double.pi/180)) * dds
        var oX = -self.dialRadius + self.xOffset - (0.5 * self.cellSize.width);
        let oY = self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y - (0.5 * self.cellSize.height)

        if isLayoutRightSide {
            oX = self.collectionView!.frame.size.width + self.dialRadius - self.xOffset - (0.5 * self.cellSize.width)
            rX *= -1
        }

        let itemFrame = CGRect(x: oX + CGFloat(rX), y: oY + CGFloat(rY), width: self.cellSize.width, height: self.cellSize.height)

        return itemFrame
    }


    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var theLayoutAttributes = Array<UICollectionViewLayoutAttributes>()

        let maxVisiblesHalf:Int = 180 / Int(self.angularSpacing)

        for i in 0 ..< self.cellCount {
            let itemFrame = self.getRectForItem(i)

            if rect.intersects(itemFrame) && i > (-1 * Int(self.offset) - maxVisiblesHalf) && i < (-1 * Int(self.offset) + maxVisiblesHalf) {
                let indexPath = IndexPath(item: i, section: 0)
                let theAttributes = self.layoutAttributesForItem(at: indexPath)
                theLayoutAttributes.append(theAttributes!)
            }
        }

        return theLayoutAttributes;
    }

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if shouldSnap {
            let index = Int(floor(proposedContentOffset.y / self.itemHeight))
            let off = (Int(proposedContentOffset.y) % Int(self.itemHeight))

            let height = Int(self.itemHeight)

            var targetY = index * height
            if( off > Int((self.itemHeight * 0.5)) && index <= self.cellCount) {
                targetY = (index+1) * height
            }

            return CGPoint(x: proposedContentOffset.x, y: CGFloat(targetY))
        } else {
            return proposedContentOffset
        }
    }


    override public func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        return IndexPath(item: 0, section: 0)
    }

    override public var collectionViewContentSize : CGSize {
        return CGSize(width: self.collectionView!.bounds.size.width, height: CGFloat(self.cellCount-1) * self.itemHeight + self.collectionView!.bounds.size.height)
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let newIndex = CGFloat(indexPath.item) + self.offset

        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.size = self.cellSize

        var scaleFactor: CGFloat!
        var translationT: CGAffineTransform!

        let rotationValue = self.angularSpacing * newIndex * CGFloat(Double.pi/180)
        var rotationT = CGAffineTransform(rotationAngle: rotationValue)

        if isLayoutRightSide {
            rotationT = CGAffineTransform(rotationAngle: -rotationValue)
        }

        if( self.wheelType == .Left){
            scaleFactor = fmax(0.6, 1 - fabs( CGFloat(newIndex) * 0.25))
            let newFrame = self.getRectForItem(indexPath.item)
            attribute.frame = CGRect(x: newFrame.origin.x , y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)

            translationT = CGAffineTransform(translationX: 0 , y: 0)
        } else {
            scaleFactor = fmax(0.4, 1 - fabs( CGFloat(newIndex) * 0.50))

            if isLayoutRightSide {
                attribute.center = CGPoint( x: self.collectionView!.frame.size.width + self.dialRadius - self.xOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y)

                translationT = CGAffineTransform( translationX: -1 * (self.dialRadius  + ((1 - scaleFactor) * -30)) , y: 0)
            } else {
                attribute.center = CGPoint(x: -self.dialRadius + self.xOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y);
                translationT = CGAffineTransform(translationX: self.dialRadius  + ((1 - scaleFactor) * -30) , y: 0);
            }
        }

        let scaleT:CGAffineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        if changeAlphaWhileScrolling {
            attribute.alpha = scaleFactor
        }
        attribute.isHidden = false

        if shouldTransformSize {
            attribute.transform = scaleT.concatenating(translationT.concatenating(rotationT))
        }

        return attribute
    }
}

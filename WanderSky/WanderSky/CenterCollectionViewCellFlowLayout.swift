//
//  CenterCollectionViewCellFlowLayout.swift
//  Challenge 4
//
//  Created by joão gabriel on 23/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit

class CenterCollectionViewCellFlowLayout: UICollectionViewFlowLayout {
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let screenSize = CGFloat.init(1090)
        
        //Saber quantas telas ja passaram
        var numberOfStage = (proposedContentOffset.x/screenSize).rounded(.towardZero)
        
        if velocity.x > 0{
            numberOfStage += 1
            mostRecentOffset = CGPoint(x: numberOfStage*screenSize, y: 0)
        }else if velocity.x < 0{
            mostRecentOffset = CGPoint(x: numberOfStage*screenSize, y: 0)
        }
        
        return mostRecentOffset
    }
}

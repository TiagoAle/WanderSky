//
//  stageSelectCell.swift
//  Challenge 4
//
//  Created by joão gabriel on 15/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit

class stageSelectCell: UICollectionViewCell {
    

    @IBOutlet weak var stageImageBackground: UIImageView!
    @IBOutlet weak var stageClouds: UIImageView!
    @IBOutlet weak var stageGamePlay: UIImageView!
    @IBOutlet weak var lock: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var stageTitle: UILabel!
    @IBOutlet var starsImage: [UIImageView]!
    //Parallax
    let parallaxOffsetDuringPick: CGFloat = 2.0
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused{
            self.stageImageBackground.adjustsImageWhenAncestorFocused = true
            //self.stageClouds.adjustsImageWhenAncestorFocused = true
            //self.stageGamePlay.adjustsImageWhenAncestorFocused = true
            self.stageClouds.isUserInteractionEnabled = true
            self.stageImageBackground.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.stageClouds.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.stageGamePlay.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.getParallax()
        }else{
            self.stageImageBackground.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.stageClouds.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.stageGamePlay.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.stageImageBackground.adjustsImageWhenAncestorFocused = false
            //self.stageClouds.adjustsImageWhenAncestorFocused = false
            //self.stageGamePlay.adjustsImageWhenAncestorFocused = false
            self.stageClouds.motionEffects.removeAll()
            self.stageGamePlay.motionEffects.removeAll()
        }
    }

    func getParallax(){
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                               type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                 type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        let verticalMotionEffect2 = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                               type: .tiltAlongVerticalAxis)
        verticalMotionEffect2.minimumRelativeValue = -10
        verticalMotionEffect2.maximumRelativeValue = 10
        
         //Set horizontal effect
        let horizontalMotionEffect2 = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                 type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect2.minimumRelativeValue = -10
        horizontalMotionEffect2.maximumRelativeValue = 10
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        let group2 = UIMotionEffectGroup()
        group2.motionEffects = [horizontalMotionEffect2, verticalMotionEffect2]
        
        
        // Add both effects to your view
        self.stageClouds.addMotionEffect(group)
        self.stageGamePlay.addMotionEffect(group2)
    }
    
}

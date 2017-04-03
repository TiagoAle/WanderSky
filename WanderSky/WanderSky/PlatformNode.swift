//
//  PlatformNode.swift
//  Challenge 4
//
//  Created by joão gabriel on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import SpriteKit

enum PlatformType: String {
    case release
    case landing
}

class PlatformNode: SKSpriteNode {
    
    var platformType: PlatformType
    
    required init?(coder aDecoder: NSCoder) {
        
        platformType = .release
        
        super.init(coder: aDecoder)
    }
    
    
    class func initPlatformFromSks(platformType: PlatformType) -> PlatformNode?{
        let platform = SKScene(fileNamed: "Platform")?.childNode(withName: "platform") as! PlatformNode?
        platform?.removeFromParent()
        return platform
    }
}

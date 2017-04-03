//
//  PlatformModel.swift
//  Challenge 4
//
//  Created by joão gabriel on 10/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class PlatformModel {
    
    //Adicionando uma plataforma na cena com o nome e a posicao indicados
    class func addPlatform(platformName name: String, position: CGPoint, platform: PlatformType) {
        let platformNode = PlatformNode.initPlatformFromSks(platformType: platform)
        platformNode?.name = name
        platformNode?.position = position
        
        if platform == .release{
            platformNode?.childNode(withName: "PlatF")?.removeFromParent()
        }
        
        //platformNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (platformNode?.frame.size.width)!, height: (platformNode?.frame.size.height)!*2), center: CGPoint(x: 0.5, y: 10))

        // Floor Colision
        
        let floor = platformNode!.childNode(withName: "floor")
        floor?.physicsBody = SKPhysicsBody(rectangleOf: floor!.frame.size)
        floor?.physicsBody?.isDynamic = false
        
        // Aura Contact
        let aura = platformNode?.childNode(withName: "PlatF")
        aura?.physicsBody = SKPhysicsBody(circleOfRadius: aura!.frame.size.width/2)
        aura?.physicsBody?.isDynamic = false
        aura?.physicsBody?.contactTestBitMask = PhysicsCategory.Crystal
        
        gameScene?.addChild(platformNode!)
        
        
    }
}

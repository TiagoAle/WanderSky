//
//  ArielNode.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 16/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import SpriteKit

class ArielNode: SKNode {
    
    var sprite: SKSpriteNode
    var textures = [SKTexture]()
    
    init(positionX: Double, positionY: Double) {
        self.sprite = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "ArielStand2")))
        
        
        super.init()
        
        self.position = CGPoint(x: positionX, y: positionY)
        self.setScale(0.75)
        self.zPosition = -1
        self.addChild(self.sprite)
        
        self.setWings()
        self.animations()
        self.animationsWing()
    }
    
    func setWings(){
        let wingTop1 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Wing01")))
        let wingTop2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Wing01")))
        let wingBot1 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Wing02")))
        let wingBot2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Wing02")))
        
        wingTop1.xScale = wingTop1.xScale * -1
        wingBot1.xScale = wingBot1.xScale * -1
        
        wingTop1.zPosition = -4
        wingTop2.zPosition = -4
        
        wingTop1.position = CGPoint(x: 0, y: 40)
        wingTop2.position = CGPoint(x: 0, y: 40)
        
        wingBot1.position = CGPoint(x: 0, y: -30)
        wingBot2.position = CGPoint(x: 0, y: -30)
        
        wingBot1.zPosition = -5
        wingBot2.zPosition = -5
        
        wingTop1.name = "wingTop1"
        wingTop2.name = "wingTop2"
        wingBot1.name = "wingBot1"
        wingBot2.name = "wingBot2"
        
        wingTop1.anchorPoint = CGPoint(x: 0, y: 0.5)
        wingBot1.anchorPoint = CGPoint(x: 0, y: 0.5)
        wingTop2.anchorPoint = CGPoint(x: 0, y: 0.5)
        wingBot2.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        self.addChild(wingTop1)
        self.addChild(wingTop2)
        self.addChild(wingBot1)
        self.addChild(wingBot2)
    }
    
    func animationsWing(){
        let moveWingRight = SKAction.rotate(byAngle: CGFloat(-M_PI_4)/2, duration: 2)
        let moveWingRight2 = SKAction.rotate(byAngle: CGFloat(M_PI_4/2), duration: 2)
        
        moveWingRight.timingMode = .easeInEaseOut
        moveWingRight2.timingMode = .easeInEaseOut
        
        let sequenceRight = SKAction.repeatForever(SKAction.sequence([
            moveWingRight2,
            moveWingRight
            ]))
        let sequenceLeft = SKAction.repeatForever(SKAction.sequence([
            moveWingRight,
            moveWingRight2
            ]))
        
        self.childNode(withName: "wingTop1")?.run(sequenceLeft)
        self.childNode(withName: "wingBot1")?.run(sequenceLeft)
        self.childNode(withName: "wingBot2")?.run(sequenceRight)
        self.childNode(withName: "wingTop2")?.run(sequenceRight)
    }
    
    func animations(){
        
        for number in 1...7{
            self.textures.append(SKTexture(imageNamed: "ArielStand\(number)"))
        }
        
        self.sprite.run(SKAction.repeatForever(SKAction.animate(with: self.textures, timePerFrame: 0.15)))
        
        let moveDown = SKAction.moveBy(x: 0, y: -50, duration: 2)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 2)
        
        moveUp.timingMode = .easeInEaseOut
        moveDown.timingMode = .easeInEaseOut
        
        let flying = SKAction.repeatForever(SKAction.sequence([
            moveDown,
            moveUp
            ]))
        
        flying.timingMode = .easeInEaseOut
        
        
        self.run(flying)
        //self.run(windRobe)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

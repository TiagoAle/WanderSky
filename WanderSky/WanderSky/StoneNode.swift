//
//  Stone.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 09/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation

//
//  GameScene.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import SpriteKit
import GameplayKit

class StoneNode: SKNode {
    
    var sprite: SKSpriteNode
    var pointer: SKSpriteNode
    
    override init() {
        self.sprite = SKSpriteNode()
        self.pointer = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Pointer")))
        super.init()
        
        self.addChild(pointer)
        self.addChild(sprite)
        
        
    }
    
    func setupBody(withCenter centerPoint: CGPoint, andColor color: UIColor){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.sprite.size.width/3, center: centerPoint)
        self.physicsBody?.restitution = 1
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.mass = 0.5
        
        switch color {
        case UIColor.orange:
            self.physicsBody?.categoryBitMask = PhysicsCategory.Orange
            self.physicsBody?.collisionBitMask = PhysicsCategory.Orange
            break
        case UIColor.purple:
            self.physicsBody?.categoryBitMask = PhysicsCategory.Purple
            self.physicsBody?.collisionBitMask = PhysicsCategory.Purple
            break
        case UIColor.green:
            self.physicsBody?.categoryBitMask = PhysicsCategory.Green
            self.physicsBody?.collisionBitMask = PhysicsCategory.Green
            break
        default:
            print("Cor não existe seu imundo")
            break
        }

        self.physicsBody?.contactTestBitMask = PhysicsCategory.Crystal
        
    }
    
    func shineEmitters(){
        
        let emitter = SKEmitterNode(fileNamed: "Shine")
        emitter?.name = "emitter"
        emitter?.particlePositionRange = CGVector(dx: self.sprite.size.width, dy: self.sprite.size.height)
        emitter?.targetNode = self.parent
        emitter?.particleLifetime = 1
        
        emitter?.particleScale = 0.1
        emitter?.particleBirthRate = 30
        
        emitter?.particleScaleSpeed = 0.2
        
        emitter?.position = CGPoint(x: 100, y: 50)
        
        self.addChild(emitter!)
    }
    
    func removeEmitters(){
        let emitter = self.childNode(withName: "emitter") as? SKEmitterNode
        
        emitter?.run(SKAction.sequence([
            SKAction.run {
                emitter?.particleBirthRate = 0
            },
            SKAction.wait(forDuration: 1),
            SKAction.run {
                emitter?.removeFromParent()
            }
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

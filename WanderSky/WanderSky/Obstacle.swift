//
//  Obstacle.swift
//  Challenge 4
//
//  Created by Tiago Queiroz on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Obstacle: NSObject{
    
    var name: String?
    var node: NodeObstacle!
    var color: String
    var type: String
    var isMoving: Bool
    var speed: Double?
    var distanceX: Double?
    var distanceY: Double?
    var id: Int
    var width: Double
    var height: Double
    var angle: CGFloat
    var isRotating: Bool
    var velocityRotation: Double?
    
    init(id: Int, width: Double, heigth: Double, color:String, type: String, angle: CGFloat){
        
        self.id = id
        self.width = width
        self.height = heigth
        self.isMoving = false
        self.type = type
        self.angle = angle
        self.isRotating = false
        self.color = color

        super.init()
        self.pickColor()
        self.configureObstacle()

    }
    
    //Configurando cores apartir de uma String
    func pickColor() {
        switch self.color {
        case "orange":
            self.node = NodeObstacle(withImage: #imageLiteral(resourceName: "Obstacles02"))
            break
        case "green":
            self.node = NodeObstacle(withImage: #imageLiteral(resourceName: "Obstacles01"))
            break
        case "purple":
            self.node = NodeObstacle(withImage: #imageLiteral(resourceName: "Obstacles03"))
            break
        default:
            break
        }
        
    }
    
    func configureObstacle(){
        
        self.name = "obstacle"
        
        self.initObstacle()
        self.node.name = "obstacle"
        
        //self.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: self.width, height: self.height))
        self.node.physicsBody = SKPhysicsBody(texture: SKTexture(image: #imageLiteral(resourceName: "Obstacles01")), size: CGSize.init(width: self.width, height: self.height))
        self.node.physicsBody?.affectedByGravity = false
        self.node.physicsBody?.allowsRotation = false
        self.node.physicsBody?.pinned = false
        self.node.physicsBody?.friction = 0
        self.node.physicsBody?.restitution = 1
        self.node.physicsBody?.linearDamping = 0
        self.node.physicsBody?.angularDamping = 0
        
        //Collision and Category
        
        switch self.color {
        case "orange":
            self.node.physicsBody?.categoryBitMask = PhysicsCategory.Green | PhysicsCategory.Purple
            self.node.physicsBody?.collisionBitMask = PhysicsCategory.Crystal
            self.node.physicsBody?.contactTestBitMask = PhysicsCategory.Green | PhysicsCategory.Purple
            break
        case "purple":
            self.node.physicsBody?.categoryBitMask = PhysicsCategory.Green | PhysicsCategory.Orange
            self.node.physicsBody?.collisionBitMask = PhysicsCategory.Crystal
            self.node.physicsBody?.contactTestBitMask = PhysicsCategory.Green
            break
        case "green":
            self.node.physicsBody?.categoryBitMask = PhysicsCategory.Purple | PhysicsCategory.Orange
            self.node.physicsBody?.collisionBitMask = PhysicsCategory.Crystal
            self.node.physicsBody?.contactTestBitMask = PhysicsCategory.Purple
            break
        default:
            print("Cor não existe")
            break
        }

    }
    
    func initObstacle(){
        self.node.sprite.size.width = CGFloat(self.width)
        self.node.sprite.size.height = CGFloat(self.height)
        self.node.sprite.position = CGPoint(x: 0, y: 0)
        self.node.zPosition = 10
        self.node.shineEmitters()
//        self.node.sprite.color = self.color
//        self.node.sprite.colorBlendFactor = 1
        self.node.zRotation = self.angle
        
    }
    
    func setMoviment(){
        if self.isMoving{
            let moveAction = SKAction.moveBy(x: self.node.sprite.position.x + CGFloat(self.distanceX!), y: self.node.sprite.position.y + CGFloat(self.distanceY!), duration: 10/self.speed!)
            let reverseMove = moveAction.reversed()
            self.node.run(SKAction.repeatForever(SKAction.sequence([moveAction,reverseMove])))
        }
    }
    
    func setRotation(){
        if self.isRotating{
            self.node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(-M_PI_4), duration: self.velocityRotation!)))
        }
    }
    
    
    func setSpeedDirection(speed: Double, distanceX: Double, distanceY: Double, velocityRotation: Double) {
        self.speed = speed
        self.distanceX = distanceX
        self.distanceY = distanceY
        self.isMoving = true
        self.velocityRotation = velocityRotation
        if (self.velocityRotation != 0){
            self.isRotating = true
        }

        self.setRotation()
        self.setMoviment()
    }

    
}

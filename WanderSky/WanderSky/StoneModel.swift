//
//  StoneManager.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 10/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class StoneModel : NSObject{
    
    var velocity : CGFloat
    var height: CGFloat
    var width: CGFloat
    var clockDirection : Bool
    var color : UIColor
    var node = StoneNode()
    var selected = false
    var positionX: Double?
    var positionY: Double?
    
    init(withVelocity velocity: CGFloat, andClockDirection clockDirection: Bool, andColor color: UIColor , positionX: Double, positionY: Double) {
        
        self.height = 80
        self.width = 80
        self.velocity = velocity
        self.clockDirection = clockDirection
        self.color = color
        self.positionY = positionY
        self.positionX = positionX
        self.node.position = CGPoint(x: positionX, y: positionY)
        super.init()
        
        self.setupSprite()
        self.setRotation()
        self.setSelection()
        
    }
    
    func setupSprite(){
        
        self.node.sprite.size = CGSize(width: self.width, height: self.height)
        self.node.sprite.anchorPoint = CGPoint(x:CGFloat(-0.5),y:CGFloat(0.5))
        
        self.node.pointer.anchorPoint = CGPoint(x: -4, y: 0.5)
        self.node.pointer.setScale(0.3)
        self.node.pointer.zPosition = 10
        
        
        switch color {
        case UIColor.orange:
            self.node.sprite.texture = SKTexture(image: #imageLiteral(resourceName: "Gem03"))
            break
        case UIColor.green:
            self.node.sprite.texture = SKTexture(image: #imageLiteral(resourceName: "Gem02"))
            break
        case UIColor.purple:
            self.node.sprite.texture = SKTexture(image: #imageLiteral(resourceName: "Gem01"))
            break
        default:
            break
        }
        
        
    }
    
    func setRotation(){
        var translationMovement: SKAction
        if clockDirection {
            translationMovement = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(-M_PI), duration: TimeInterval(10/self.velocity)))
        } else {
            translationMovement = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: TimeInterval(10/self.velocity)))
        }
        
        
        self.node.run(translationMovement)
    }
    
    func setSelection(){
        let centerPoint = CGPoint(x: self.node.sprite.size.width / 2 - (self.node.sprite.size.width * self.node.sprite.anchorPoint.x), y: self.node.sprite.size.height / 2 - (self.node.sprite.size.height * self.node.sprite.anchorPoint.y))
        
        if self.selected == false{
            self.node.physicsBody = nil
            self.node.run(SKAction.scale(to: 0.5, duration: 0.5))
            self.node.pointer.isHidden = true
        } else {
            self.node.run(SKAction.sequence([SKAction.scale(to: 1, duration: 0.5),SKAction.run({self.node.setupBody(withCenter: centerPoint, andColor: self.color)})]) )
            self.node.pointer.isHidden = false
        }
    }
    
    func shootStone(){
        
        // Song
        
        let song = gameScene?.childNode(withName: "crystalShootSong") as? SKAudioNode
        song?.run(SKAction.stop())
        song?.run(SKAction.play())
        
        // Stone
        self.node.removeAllActions()
        self.node.pointer.isHidden = true
        let dx = 500 * cos (self.node.zRotation);
        let dy = 500 * sin (self.node.zRotation);
        self.node.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        self.node.shineEmitters()
    }
    
}

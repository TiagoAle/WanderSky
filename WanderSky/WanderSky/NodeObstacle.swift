//
//  NodeObstacle.swift
//  Challenge 4
//
//  Created by Tiago Queiroz on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit
import SpriteKit

class NodeObstacle: SKNode {
    
    var sprite: SKSpriteNode
    
    init(withImage image: UIImage) {
         self.sprite = SKSpriteNode(texture: SKTexture(image: image))
        super.init()
        
        self.addChild(self.sprite)
        
    }
    
    func shineEmitters(){
        
        let emitter = SKEmitterNode(fileNamed: "Shine")
        emitter?.particlePositionRange = CGVector(dx: self.sprite.size.width, dy: self.sprite.size.height)
        
        
        self.addChild(emitter!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

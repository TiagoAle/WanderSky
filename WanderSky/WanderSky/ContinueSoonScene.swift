//
//  ContinueSoonScene.swift
//  Challenge 4
//
//  Created by Italus Rodrigues do Prado on 23/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

var continueSoonScene: ContinueSoonScene?

class ContinueSoonScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Ariel
        let arielScene = self.childNode(withName: "Ariel")
        let ariel = ArielNode(positionX: 0, positionY: 0)
        ariel.position = (arielScene?.position)!
        
        ariel.setScale(1.5)
        self.addChild(ariel)
        arielScene?.removeFromParent()
        
        let purple = self.childNode(withName: "purple")
        let green = self.childNode(withName: "green")
        
        
        // Shines
        let emitter1 = SKEmitterNode(fileNamed: "Shine")
        emitter1?.particlePositionRange = CGVector(dx: purple!.frame.size.height, dy: purple!.frame.size.width)
        
        
        purple!.addChild(emitter1!)
        
        let emitter2 = SKEmitterNode(fileNamed: "Shine")
        emitter2?.particlePositionRange = CGVector(dx: green!.frame.size.height, dy: green!.frame.size.width)
        
        //Menu volta pro menu, porque é um jogo bem relaxante pra relaxar as pessoas e deixar elas bem relaxadas

        
        green!.addChild(emitter2!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

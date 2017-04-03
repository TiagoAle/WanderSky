//
//  ComingSoonController.swift
//  Challenge 4
//
//  Created by Italus Rodrigues do Prado on 07/03/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class CommingSoonViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GKScene(fileNamed: "ContinueSoonScene"){
                // Set the scale mode to scale to fit the window
                
                continueSoonScene = scene.rootNode as! ContinueSoonScene?
                if let sceneNode = continueSoonScene{
                    sceneNode.size = CGSize(width: 1024, height: 768)
                    sceneNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    sceneNode.scaleMode = .aspectFill
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(sceneNode)
                }
            }
            //            view.ignoresSiblingOrder = true
            //            view.showsFPS = true
            //            view.showsNodeCount = true
            //            view.showsPhysics = true
        }
        let menu = UITapGestureRecognizer(target: self, action: #selector(self.changeToMenu))
        menu.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        //self.view!.addGestureRecognizer(menu)
    }
    
    func changeToMenu() {
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MenuController.menuController?.audioPlayer.pause()
    }
}

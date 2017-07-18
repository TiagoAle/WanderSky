//
//  GameViewController.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    //var stageSelectController: StageSelectController?
    var sceneToDelete : GameScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GKScene(fileNamed: "GameScene"){
                // Set the scale mode to scale to fit the window
                
                gameScene = scene.rootNode as! GameScene?
                var sceneNode = gameScene
                sceneNode?.size = CGSize(width: 1024, height: 768)
                sceneNode?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                sceneNode?.scaleMode = .aspectFill
                // Set the scale mode to scale to fit the window
                sceneNode?.scaleMode = .aspectFill
                // Present the scene
                sceneNode?.viewController = self
                sceneToDelete = sceneNode
                sceneNode = nil
                view.presentScene(sceneToDelete)
            }
            //            view.ignoresSiblingOrder = true
            //            view.showsFPS = true
            //            view.showsNodeCount = true
            //            view.showsPhysics = true
        }
    }
    
    //Recarrega a Collection VIew
    //    override func viewWillDisappear(_ animated: Bool) {
    //
    //        if let reloadCollectionView = stageSelectController{
    //            reloadCollectionView.collectionView?.reloadData()
    //        }else{
    //            print("Nao existe Collection View")
    //        }
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameScene?.childNode(withName: "music")?.removeFromParent()

        if gameScene?.gameManager?.actualPhase != 9{
            gameScene?.removeAllChildren()
            gameScene?.removeAllActions()
        }

        if (MenuController.loadPlayerMusicPreference()){
            MenuController.menuController?.audioPlayer.play()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func changToComingSoon(){
        self.performSegue(withIdentifier: "segueGame", sender: self)
    }
    
}

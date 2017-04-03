//
//  GameScene.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 08/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

var gameScene: GameScene?

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var stone = StoneModel(withVelocity: 10, andClockDirection: false, andColor: .purple)
    //var stone2 = StoneModel(withVelocity: 5, andClockDirection: true, andColor: .green)

    weak var viewController : GameViewController?
    var gameManager: GameManager?
    var gameLoadManager: GameLoadManager?
    var frameSize = CGSize()
    var delegating = false
    var count = 0
    var tutorialStep = 1
    
    override func didMove(to view: SKView) {

        let stage = MenuController.loadPlayerStageInNSUserDefault()
        print(stage)
        self.gameLoadManager = GameLoadManager()
        self.gameLoadManager?.configurePhases()
        
        self.frameSize = self.frame.size
        self.frameSize.width = self.frameSize.width+self.camera!.position.x+50
        self.frameSize.height = self.frameSize.height+self.camera!.position.y+50
        
        // Removendo gravidade do jogo
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Pegando tamanho da tela para posicionar objetos
        self.frameSize = self.frame.size
        self.frameSize.width = self.frameSize.width+self.camera!.position.x+50
        self.frameSize.height = self.frameSize.height+self.camera!.position.y+50

        // Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTap(_:)))
        tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.view!.addGestureRecognizer(tap)
        
        let menu = UITapGestureRecognizer(target: self, action: #selector(GameScene.pauseGame(_:)))
        menu.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view!.addGestureRecognizer(menu)
        
        // Swipe
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handleSwipe(_:)))
        swipeGestureRight.direction = .right
        self.view?.addGestureRecognizer(swipeGestureRight)
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handleSwipe(_:)))
        swipeGestureLeft.direction = .left
        self.view?.addGestureRecognizer(swipeGestureLeft)
        
        /// ---------------------------------------------------------
        
        // Configurando pedras, mudar isso depois
        
        self.setStones()
    }
    
    //Configura e adiciona as pedras na cena
    func setStones() {
        self.gameManager = GameManager(withArrayStones: [(gameLoadManager?.stone)!,(gameLoadManager?.stone2)!], andLimit: self.frameSize)
        if self.gameManager?.actualPhase == 0{
            self.gameManager?.setTutorial(withTutorialType: tutorialStep)
        } else {
            self.tutorialStep = 4
        }
        
        for stone in self.gameManager!.arrayStones{
            if stone == self.gameManager?.arrayStones.first{
                stone.selected = true
                stone.setSelection()
            }
            self.addChild(stone.node)
        }
    }
    
    func handleTap(_ gesture: UIGestureRecognizer){
        if self.tutorialStep > 3 {
            gameManager?.selectStoneToShoot()
        } else if tutorialStep == 3{
            self.childNode(withName: "aura")?.removeFromParent()
            self.childNode(withName: "blackBG")?.removeFromParent()
            self.childNode(withName: "label")?.removeFromParent()
            tutorialStep = tutorialStep+1
        } else {
            tutorialStep = tutorialStep+1
            self.gameManager?.setTutorial(withTutorialType: tutorialStep)
        }
        
    }
    
    func pauseGame(_ gesture: UIGestureRecognizer){
        gameManager?.showPopUp(withStatus: 2)
    }
    
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer){
        if tutorialStep > 3{
            if !(self.gameManager?.shooting)!{
                self.run(SKAction.sequence([SKAction.run {self.gameManager?.shooting = true},
                                            SKAction.wait(forDuration: 0.5),
                                            SKAction.run {self.gameManager?.shooting = false}
                    ]))
            }
            gameManager?.changeStone(withDirection: gesture.direction)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "obstacle" || contact.bodyB.node?.name == "obstacle"{
            let song = self.childNode(withName: "crystalSong") as? SKAudioNode
            song?.run(SKAction.stop())
            song?.run(SKAction.play())
        }
        gameManager?.finishStage(withContact: contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Delegate de contato
        if !delegating && count == 10{
            self.physicsWorld.contactDelegate = self
            self.delegating = true
        } else if !delegating{
            count += 1
        }
        
        self.gameManager?.returnStone()
    }
}

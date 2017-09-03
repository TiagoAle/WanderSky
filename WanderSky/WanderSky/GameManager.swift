//
//  GameManager.swift
//  Challenge 4
//
//  Created by Italus Trabalho on 12/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

struct PhysicsCategory {
    static let Crystal : UInt32 = 0x1 << 0
    static let Orange : UInt32 = 0x1 << 1
    static let Purple : UInt32 = 0x1 << 2
    static let Green : UInt32 = 0x1 << 3
}


class GameManager : NSObject{
    
    
    var arrayStones: [StoneModel]
    var stoneSelectedPosition = 0
    var limit: CGSize
    var shooting = false
    var lifes = 7
    var endCrystal = 0
    var actualPhase = MenuController.loadPlayerStageInNSUserDefault()
    var diferentPopUp = false
    var currentStars = 0
    
    let music = SKAudioNode(fileNamed: "crystalsky")
    let crystalSong = SKAudioNode(fileNamed: "crystal")
    let crystalShootSong = SKAudioNode(fileNamed: "crystalshoot")
    
    // Tutorial Sprites
    let finger = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Hand")))
    let remote = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "SiriRemote")))
    let blackBG = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "BlackTransparentBackground")))
    
    init(withArrayStones arrayStones: [StoneModel], andLimit limit: CGSize) {
        
        self.arrayStones = arrayStones
        self.limit = limit
        
        super.init()
        self.showLifes()
        self.setBackground()
        self.setEmitters()
        self.createClouds()
        self.checkMusicPreference()
        self.checkSongPreference()
    }
    
    /////////////////
    
    //Reduz a vida do jogador
    func reduceLifes() {
        
        if let childFront = gameScene?.childNode(withName: "lifes\(self.lifes)"){
            
            childFront.removeFromParent()
            
            let scale = SKAction.run{
                childFront.run(SKAction.scale(to: 0, duration: 1))
            }
            
            let remove = SKAction.run {
                childFront.removeFromParent()
                
            }
            
            let removeSequence = SKAction.sequence([
                scale,
                remove
                ])
            print(self.lifes)
            
            gameScene!.run(removeSequence)
            self.lifes = self.lifes - 1
            if self.lifes == 0{
                self.endGame()
            }
        }
    }
    
    //Adiciona os nodes das vidas restantes do jogador
    func showLifes() {
        //print("adicionando")
        for i in 1...self.lifes{
            let spriteLifes = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Gem04")))
            let spritemid = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Crystal2")))
            let spriteback = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Crystal3")))
            
            spriteLifes.name = "lifes\(i)"
//            spritemid.name = "lifes\(i)mid"
//            spriteback.name = "lifes\(i)back"
            
            let x = gameScene?.camera?.position.x
            let y = gameScene?.camera?.position.y
            spriteLifes.position = CGPoint(x: x! + 600 + CGFloat(i*50), y:y!+490.0)
            spriteLifes.size = CGSize(width: 50, height: 50)

            gameScene?.addChild(spriteLifes)
            
            //spriteLifes.addChild(spritemid)
            //spriteLifes.addChild(spriteback)
            
            spriteLifes.zPosition = 3
            spritemid.zPosition = 4
            spriteback.zPosition = 5
        }
    }
    
    /////////////////
    
    
    func changeStone(withDirection direction: UISwipeGestureRecognizerDirection){
        
        if (!self.shooting && endCrystal == 0){
            switch direction {
            case UISwipeGestureRecognizerDirection.left:
                if self.stoneSelectedPosition-1 >= 0{
                    arrayStones[self.stoneSelectedPosition].selected = false
                    arrayStones[self.stoneSelectedPosition-1].selected = true
                    self.stoneSelectedPosition = self.stoneSelectedPosition-1
                } else {
                    arrayStones[self.stoneSelectedPosition].selected = false
                    arrayStones.last?.selected = true
                    self.stoneSelectedPosition = arrayStones.count-1
                }
                break
            case UISwipeGestureRecognizerDirection.right:
                if self.stoneSelectedPosition+1 < arrayStones.count{
                    arrayStones[self.stoneSelectedPosition].selected = false
                    arrayStones[self.stoneSelectedPosition+1].selected = true
                    self.stoneSelectedPosition += 1
                } else {
                    arrayStones[self.stoneSelectedPosition].selected = false
                    arrayStones.first?.selected = true
                    self.stoneSelectedPosition = 0
                }
                
                break
            default:
                break
            }
            
            for stoneSelected in arrayStones {
                stoneSelected.setSelection()
            }
        }
        
    }
    
    func selectStoneToShoot(){
        let stone = self.arrayStones[self.stoneSelectedPosition]
        
        if stone.node.physicsBody != nil{
            if !self.shooting{
                self.shooting = true
                self.arrayStones[stoneSelectedPosition].shootStone()
            }
        }
        
    }
    
    func returnStone(){
        
        let stone = self.arrayStones[self.stoneSelectedPosition]
        
        if stone.node.position.x < -limit.width{
            self.reestrutureStone()
        } else if stone.node.position.x > limit.width{
            self.reestrutureStone()
        }
        
        if stone.node.position.y < -limit.height{
            self.reestrutureStone()
        } else if stone.node.position.y > limit.height{
            self.reestrutureStone()
        }
    }
    
    func reestrutureStone(){
        let stone = self.arrayStones[self.stoneSelectedPosition]
        let parent = stone.node.parent
        
        self.arrayStones[stoneSelectedPosition].node.removeEmitters()
        stone.node.removeFromParent()
        stone.node.position = CGPoint(x: stone.positionX!, y: stone.positionY!)
        stone.node.setScale(0)
        parent?.addChild(stone.node)
        stone.node.pointer.isHidden = false
        stone.node.run(SKAction.sequence([SKAction.scale(to: 1, duration: 0.5),SKAction.run{self.shooting = false}]))
        stone.setRotation()
        
        self.reduceLifes()
    }
    
    func finishStage(withContact contact: SKPhysicsContact){
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        if (bodyA?.name == "PlatF" || bodyB?.name == "PlatF"){
            
            self.stopCrystal()
            self.shooting = false
            self.changeStone(withDirection: .right)
            
            if(endCrystal == 1) {
                
                //Adicionando novos nós da nova fase
                self.saveStars()
                MenuController.savehigherStageInUserDefault(stage: self.actualPhase+1)
                
                gameScene?.run(SKAction.sequence([SKAction.run{self.stopCrystal()},SKAction.wait(forDuration: 3),SKAction.run{self.showPopUp(withStatus: 3)}]))

            }
            endCrystal += 1
        }
    }
    
    func saveStars(){
        var stars = 0
        
        if self.lifes >= 6{
            stars = 3
        }else if self.lifes > 3{
            stars = 2
        } else {
            stars = 1
        }
        self.currentStars = stars
        print("SALVANDO")
        gameScene?.gameLoadManager?.updateJsonStars(index: self.actualPhase, stars: stars)
    }
    
    func restartGame(){
        gameScene?.removeAllChildren()
        gameScene?.removeAllActions()
        
        //let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 5.0)
        
        gameScene?.gameLoadManager?.setPhase(indexPhase: self.actualPhase)
        
        //self.setBackground()
        //gameScene?.gameManager?.lifes = 7
        gameScene?.setStones()
        
    }
    
    func setEmitters(){
        
        let emitter1 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter1"
        emitter1?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter1?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter2 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter2"
        emitter2?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter2?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass02"))
        emitter2?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter3 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter3"
        emitter3?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter3?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass03"))
        emitter3?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter4 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter4"
        emitter4?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter4?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass04"))
        emitter4?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter5 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter5"
        emitter5?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter5?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass05"))
        emitter5?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter6 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter6"
        emitter6?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter6?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass06"))
        emitter6?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        let emitter7 = SKEmitterNode(fileNamed: "Glass")
        emitter1?.name = "emitter7"
        emitter7?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: 0)
        emitter7?.particleTexture = SKTexture(image: #imageLiteral(resourceName: "Glass07"))
        emitter7?.particlePositionRange = CGVector(dx: 0, dy: (gameScene?.frameSize.height)!*5)
        
        
        gameScene?.childNode(withName: "emitter1")?.removeFromParent()
        gameScene?.childNode(withName: "emitter2")?.removeFromParent()
        gameScene?.childNode(withName: "emitter3")?.removeFromParent()
        gameScene?.childNode(withName: "emitter4")?.removeFromParent()
        gameScene?.childNode(withName: "emitter5")?.removeFromParent()
        gameScene?.childNode(withName: "emitter6")?.removeFromParent()
        gameScene?.childNode(withName: "emitter7")?.removeFromParent()
        
        gameScene?.addChild(emitter1!)
        gameScene?.addChild(emitter2!)
        gameScene?.addChild(emitter3!)
        gameScene?.addChild(emitter4!)
        gameScene?.addChild(emitter5!)
        gameScene?.addChild(emitter6!)
        gameScene?.addChild(emitter7!)
        
    }
    
    func createClouds(){
        
        let action = SKAction.run{
            let type = arc4random()%2
            var scale = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            let positionRand = CGFloat(arc4random()%1200)-500
            //print(positionRand)
            if scale < 0.5{
                scale = 0.5
            }
            
            if type == 0 {
                var cloud : SKSpriteNode? = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Cloud")))
                cloud?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: positionRand)
                
                cloud?.setScale(scale)
                
                let move = SKAction.move(by: CGVector(dx: -2700, dy: 0), duration: 40)
                let remove = SKAction.run { cloud?.removeFromParent() }
                cloud?.run(SKAction.sequence([move, remove,SKAction.run{cloud = nil}]))
                
                
                cloud?.zPosition = -8
                gameScene?.addChild(cloud!)
                
            } else {
                var cloud : SKSpriteNode? = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "CloudBlur")))
                
                cloud?.position = CGPoint(x: (gameScene?.frameSize.width)!*1.2, y: positionRand)
                cloud?.setScale(scale)
                
                let move = SKAction.move(by: CGVector(dx: -2700, dy: 0), duration: 60)
                let remove = SKAction.run { cloud?.removeFromParent() }
                cloud?.run(SKAction.sequence([move, remove,SKAction.run{cloud = nil}]))
                
                cloud?.zPosition = -9
                gameScene?.addChild(cloud!)
            }
            
        }
        
        gameScene?.run(SKAction.repeatForever(SKAction.sequence([action, SKAction.wait(forDuration: 10)])))
        
    }
    
    func stopCrystal() {
        
        self.arrayStones[stoneSelectedPosition].node.removeEmitters()
        self.arrayStones[stoneSelectedPosition].node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        //if you would also like to stop any rotation that may be present
        self.arrayStones[stoneSelectedPosition].node.physicsBody?.angularVelocity = 0
        let platFinal = gameScene?.childNode(withName: "PlatF")

        let stone = self.arrayStones[self.stoneSelectedPosition].node
        let changeAP = SKAction.run {
            stone.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        let rotate = SKAction.rotate(byAngle: CGFloat(2*M_PI), duration: 1)
        stone.run(SKAction.sequence([rotate,changeAP,rotate]))
        stone.physicsBody = nil
        stone.zPosition = CGFloat(10-endCrystal)
        stone.run(SKAction.move(to: CGPoint(x: (platFinal?.position)!.x,y: (platFinal?.position)!.y+150
        ), duration: 1))

        
    }
    

    func showPopUp(withStatus status: Int){
        if diferentPopUp == false{
            if status != 2{
                diferentPopUp = true
            }
            if ((gameScene?.isPaused)! == false){
                gameScene?.isPaused = true
                let popUp = PopUpview.instanceFromNib() as! PopUpview
                popUp.frame.size = UIScreen.main.bounds.size
                popUp.statusPopUp(withStatus: status)
                //popUp.nextLevel.isEnabled = false
                popUp.tag = 10
                popUp.transform = popUp.transform.scaledBy(x: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.5, animations: {
                    popUp.transform = popUp.transform.scaledBy(x: 10, y: 10)
                })
                gameScene?.view?.addSubview(popUp)
            }else{
                gameScene?.isPaused = false
                gameScene?.view?.viewWithTag(10)?.removeFromSuperview()
            }
            
        }
        

    }
    
    func endGame(){
        self.showPopUp(withStatus: 1)
    }
    
    func setBackground(){
        let bg = SKSpriteNode(imageNamed: "BGRounded0\(self.actualPhase%6)")
        bg.position = (gameScene?.camera?.position)!
        bg.size = CGSize(width: (gameScene?.frameSize.width)!*1.55, height: (gameScene?.frameSize.height)!*1.15)
        bg.zPosition = -10
        gameScene?.addChild(bg)
    }
    
    func setTutorial(withTutorialType tutorial: Int){
        
        if tutorial == 1{
            self.finger.size = CGSize(width: self.finger.frame.size.width/3, height: self.finger.frame.size.height/3)
            self.remote.size = CGSize(width: self.remote.frame.size.width/1.3, height: self.remote.frame.size.height/1.3)
            self.blackBG.size = CGSize(width: gameScene!.frameSize.width*2, height: gameScene!.frameSize.height*2)
        }
        self.finger.removeAllActions()
        self.remote.removeFromParent()
        self.remote.removeAllChildren()
        
        self.finger.zPosition = 22
        self.remote.zPosition = 20
        self.blackBG.zPosition = 19
        
        self.finger.position = CGPoint(x: 15, y: 80)
        self.remote.position = (gameScene?.camera?.position)!
        self.remote.position.y = remote.position.y-100
        self.remote.position.x = remote.position.x-200
        self.blackBG.position = (gameScene?.camera?.position)!
        
        self.blackBG.alpha = 0.7
        
        if tutorial < 3{
            self.remote.addChild(blackBG)
            self.remote.addChild(finger)
            gameScene!.addChild(remote)
        }
        
        
        
        tutorialType(withTutorialType: tutorial)
    }
    
    func tutorialType(withTutorialType tutorial: Int){
        switch tutorial {
        case 1:
            //Label
            let label = SKLabelNode(fontNamed: "BlackChancery")
            label.text = "Press to shoot stone"
            label.fontSize = 150
            label.position = CGPoint(x: 200, y: 450)
            label.zPosition = 21
            remote.addChild(label)
            
            //Action finger
            let wait = SKAction.wait(forDuration: 0.8)
            let changeScale = SKAction.scale(to: 0.80, duration: 0.8)
            let returnScale = SKAction.scale(to: 1, duration: 0.8)
            let repeatScaleForever = SKAction.repeatForever(SKAction.sequence([changeScale,wait,returnScale,wait]))
            self.finger.run(repeatScaleForever)
            
            // Add Tap Circle
            let circle = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Circle")))
            circle.setScale(0.5)
            circle.zPosition = 21
            circle.position = CGPoint(x: -10, y: 170)
            circle.isHidden = true
            self.remote.addChild(circle)
            
            // Action Circle
            let circleIncreaseScale = SKAction.scale(to: 0.7, duration: 0.4)
            let circleReturnScale = SKAction.scale(to: 0.5, duration: 0.4)
            let changeHidden = SKAction.run {
                if circle.isHidden == true{
                    circle.isHidden = false
                } else {
                    circle.isHidden = true
                }
            }
            let repeatCircleForever = SKAction.repeatForever(SKAction.sequence([wait,changeHidden,circleIncreaseScale,circleReturnScale,changeHidden,wait,wait]))
            circle.run(repeatCircleForever)
            
            // Stone animation
            
            // Stone
            let stone = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Gem01")))
            stone.zPosition = 20
            stone.position = CGPoint(x: 200, y: 0)
            stone.setScale(0.5)
            remote.addChild(stone)
            
            // Pointer
            let pointer = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Pointer")))
            pointer.zPosition = 20
            pointer.position = stone.position
            pointer.position.x = pointer.position.x+60
            pointer.position.y = pointer.position.y-10
            pointer.zRotation = 25
            pointer.setScale(0.3)
            //pointer.alpha = 0.5
            remote.addChild(pointer)
            
            // Animated Stone
            //            let stone2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Gem01")))
            //            stone2.zPosition = 20
            //            stone2.position = stone.position//CGPoint(x: 350, y: -30)
            //            stone2.setScale(0.5)
            //            remote.addChild(stone2)
            
            // Animation Stone Shooting
            let wait2 = SKAction.wait(forDuration: 1)
            let originalPosition = stone.position
            let actionShoot = SKAction.moveBy(x: 600, y: -120, duration: 1.7)
            let returnToPosition = SKAction.move(to: originalPosition, duration: 0.5)
            let changeHiddenStone = SKAction.run {
                if stone.isHidden == true{
                    stone.isHidden = false
                } else {
                    stone.isHidden = true
                }
            }
            let animationShootForever = SKAction.repeatForever(SKAction.sequence([
                wait2,
                SKAction.run{pointer.isHidden = true},
                actionShoot,
                changeHiddenStone,
                returnToPosition,
                changeHiddenStone,
                SKAction.run{pointer.isHidden = false}
                ]))
            
            stone.run(animationShootForever)
            
            break
        case 2:
            //Label
            let label = SKLabelNode(fontNamed: "BlackChancery")
            label.text = "Swipe to change stone"
            label.fontSize = 150
            label.position = CGPoint(x: 200, y: 450)
            label.zPosition = 21
            remote.addChild(label)
            
            //Action finger
            let wait = SKAction.wait(forDuration: 0.8)
            let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 0.8)
            let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 0.8)
            let repeatScaleForever = SKAction.repeatForever(SKAction.sequence([moveRight,wait,moveLeft,wait]))
            self.finger.run(repeatScaleForever)
            
            // Stone 1
            let stone = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Gem01")))
            stone.zPosition = 20
            stone.position = CGPoint(x: 300, y: -50)
            stone.setScale(0.5)
            remote.addChild(stone)
            
            // Stone 2
            let stone2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Gem02")))
            stone2.zPosition = 20
            stone2.position = CGPoint(x: 500, y: -50)
            stone2.setScale(0.25)
            remote.addChild(stone2)
            
            // Animation Stones
            
            let increaseScale = SKAction.scale(to: 0.5, duration: 0.8)
            let decreaseScale = SKAction.scale(to: 0.25, duration: 0.8)
            let animationScaleForever1 = SKAction.repeatForever(SKAction.sequence([increaseScale,wait,decreaseScale,wait]))
            let animationScaleForever2 = SKAction.repeatForever(SKAction.sequence([decreaseScale,wait,increaseScale,wait]))
            
            stone2.run(animationScaleForever1)
            stone.run(animationScaleForever2)
            
            
            break
        case 3:
            //Label
            let label = SKLabelNode(fontNamed: "BlackChancery")
            label.text = "Try to hit the gems in the ring."
            label.name = "label"
            label.fontSize = 150
            label.position = CGPoint(x: (gameScene?.camera?.position.x)!, y: (gameScene?.camera?.position.y)!-100)
            label.zPosition = 21
            gameScene?.addChild(label)
            
            // Black BG
            self.blackBG.name = "blackBG"
            self.blackBG.zPosition = 19
            self.blackBG.size = CGSize(width: gameScene!.frameSize.width*2, height: gameScene!.frameSize.height*2)
            self.blackBG.position = (gameScene?.camera?.position)!
            gameScene?.addChild(self.blackBG)
            
            // Aura
            let aura = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Halo")))
            aura.name = "aura"
            aura.zPosition = 25
            aura.position = CGPoint(x: 720, y: 550)
            gameScene?.addChild(aura)
            
            // Aura Animations
            let auraScaleIncrease = SKAction.scale(to: 1.05, duration: 1)
            let auraScaleDecrease = SKAction.scale(to: 0.95, duration: 1)
            let auraAlphaIncrease = SKAction.fadeAlpha(to: 1, duration: 1)
            let auraAlphaDecrease = SKAction.fadeAlpha(to: 0.7, duration: 1)
            
            let auraScaleSequence = SKAction.repeatForever(SKAction.sequence([auraScaleDecrease,auraScaleIncrease]))
            let auraAlphaSequence = SKAction.repeatForever(SKAction.sequence([auraAlphaDecrease,auraAlphaIncrease]))
            
            let actionGroup = SKAction.group([auraAlphaSequence,auraScaleSequence])
            
            aura.run(actionGroup)
            
        default:
            print("Tutorial Type error")
        }
    }
    
    func musicRun(){
        MenuController.menuController?.audioPlayer.pause()
        
        music.name = "music"
        music.autoplayLooped = true
        music.run(SKAction.play())
        gameScene?.addChild(music)
    }
    
    func checkMusicPreference() {
        if MenuController.loadPlayerMusicPreference() {
            self.musicRun()
        }
    }
    
    func checkSongPreference() {
        if MenuController.loadPlayerSoundPreference(){
            self.song()
        }
    }
    
    func song(){
        
        crystalSong.name = "crystalSong"
        crystalSong.autoplayLooped = false
        gameScene?.addChild(crystalSong)
        
        crystalShootSong.name = "crystalShootSong"
        crystalShootSong.autoplayLooped = false
        crystalShootSong.run(SKAction.changeVolume(by: 10
            , duration: 1))
        gameScene?.addChild(crystalShootSong)
    }
}

//
//  PopUpview.swift
//  Challenge 4
//
//  Created by Tiago Queiroz on 06/03/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit

class PopUpview: UIView{
    
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet var stars: [UIImageView]!
    
    @IBOutlet weak var retry: UIButton!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var nextLevel: UIButton!
    
    var focusedView: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PopUpLoser", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    // Define o tipo de popup que vai aparecer
    // 1 = Perdeu, 2 = Pause, 3 = Ganhou
    func statusPopUp(withStatus statusType: Int){
        self.labelLevel.text = "Stage \(MenuController.loadPlayerStageInNSUserDefault()+1)"
        switch statusType {
        case 1:
            self.nextLevel.isEnabled = false
            self.status.isHidden = true
            for star in stars{
                star.isHidden = true
            }
            self.secondLabel.text = "You Lose"
            break
        case 2:
            self.nextLevel.isEnabled = false
            self.status.isHidden = true
            for star in stars{
                star.isHidden = true
            }
            self.secondLabel.text = "Paused"
            break
        default:
            self.status.isHidden = true
            for star in stars{
                star.isHidden = false
            }
            let aux = gameScene?.gameManager?.currentStars
            for i in 0...aux!-1{
                stars[i].image = #imageLiteral(resourceName: "Star")
            }
            //self.secondLabel.text = "Level Cleared"
            self.nextLevel.isEnabled = true
            self.status.isHidden = false
            self.secondLabel.isHidden = true
            break
        }
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
        
    }
    
    @IBAction func nextPhase(_ sender: Any) {
        if gameScene?.gameManager?.actualPhase == 9{
            gameScene?.viewController?.changToComingSoon()
        } else {
            self.removeFromSuperview()
            MenuController.savePlayerStageInNSUserDefault(stage: (gameScene?.gameManager?.actualPhase)!+1)
            gameScene?.gameManager?.actualPhase = MenuController.loadPlayerStageInNSUserDefault()
            gameScene?.gameManager?.restartGame()
        }
        gameScene?.isPaused = false
    }
    
    
    @IBAction func retryAction(_ sender: Any) {
        gameScene?.isPaused = false
        gameScene?.gameManager?.restartGame()
        gameScene?.isPaused = false
        self.removeFromSuperview()
    }
    
    @IBAction func homeAction(_ sender: Any) {
        gameScene?.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

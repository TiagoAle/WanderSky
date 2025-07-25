//
//  StageSelectController.swift
//  Challenge 4
//
//  Created by joão gabriel on 14/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import UIKit

class StageSelectController: UICollectionViewController{
    
    var stars = [String:Int]()
    override func viewDidLoad() {

        //Adicionando o Blur
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        //Alpha do Blur
//        blurEffectView.alpha = 0.5
//        blurEffectView.frame = (self.collectionView?.bounds)!
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        //Background Menu
//        let imageMenu = UIImageView(image: UIImage.init(named: "BG00Menu"))
//        
//        //Ariel Background
//        let imageArielMenu = UIImageView.init(frame: CGRect(x: -480, y: 0, width: 1570, height: 1080))
//         imageArielMenu.image = UIImage(named: "BGMenu")
//
//        imageMenu.addSubview(imageArielMenu)
//        imageMenu.addSubview(blurEffectView)
//        
//        self.collectionView?.backgroundView = imageMenu
        self.stars = GameLoadManager.readJsonStars()
        //print(MenuController.loadPlayerStageInNSUserDefault()+1)
       // let indexPath = IndexPath.init(item: MenuController.loadPlayerStageInNSUserDefault(), section: 0)
        //self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    @IBAction func backHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let length = self.collectionView?.numberOfItems(inSection: 0)
        if (MenuController.loadPlayerStageInNSUserDefault() < length!){
            let indexPath = IndexPath.init(item: MenuController.loadPlayerStageInNSUserDefault(), section: 0)
            self.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }else{
            let indexPath = IndexPath.init(item: length!-1, section: 0)
            self.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! stageSelectCell
//        cell.stageImage.layer.cornerRadius = 20
//        cell.stageImage.layer.masksToBounds = true
        cell.check.image = nil
        cell.lock.image = nil
        
        
        
        //Variar entre os backgrounds disponiveis
        let valorBG = CGFloat.init(indexPath.item)
        cell.stageImageBackground.image = UIImage(named: "BGRounded0\(valorBG.truncatingRemainder(dividingBy: 6))")
        
        cell.stageClouds.image = UIImage(named: "Cloud0\(valorBG.truncatingRemainder(dividingBy: 3))")

        cell.stageTitle.text = "LEVEL \(indexPath.item+1)"
        if indexPath.item + 1 < 10{
            cell.stageGamePlay.image = UIImage(named: "FrontStage0\(indexPath.item + 1)")
        }else{
            cell.stageGamePlay.image = UIImage(named: "FrontStage\(indexPath.item + 1)")
        }
        var aux = self.stars["fase\(indexPath.item)"]!
        for i in 0...2{
            if aux > 0{
                cell.starsImage[i].image = #imageLiteral(resourceName: "Star")
                aux = aux-1
            }else{
                cell.starsImage[i].image = #imageLiteral(resourceName: "StarDisabled")
            }
        }
        
        let stage = MenuController.loadPlayerStageInNSUserDefault()
        let higherStage = MenuController.loadHigherStageInNSUserDefault()
        if indexPath.item <= higherStage {
            if indexPath.item == stage  {
                cell.check.image = UIImage(named: "check")
            }else{
            }
        }else{
            cell.lock.image = UIImage(named: "Padlock")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let higherStage = MenuController.loadHigherStageInNSUserDefault()
        
        MenuController.savePlayerStageInNSUserDefault(stage: indexPath.item)
        
        //Recarregar a collection view
        self.collectionView?.reloadData()
       
        if indexPath.item <= higherStage{
            let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameView") as! GameViewController
            //gameViewController.stageSelectController = self
            self.present(gameViewController, animated: true, completion: nil)
        }else{
            // Colocar um som de nao acesso
        }
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let cells = collectionView?.visibleCells as? [stageSelectCell] {
//            for pCell in cells {
//                let xOffset = (((collectionView?.contentOffset.x)! - pCell.frame.origin.x) / pCell.stageImageBackground.frame.width) * 20.0
//                print(pCell.frame.origin.y)
//                pCell.offset(offset: CGPoint(x: xOffset, y: pCell.stageImageBackground.frame.origin.y))
//            }
//        }
//    }

}

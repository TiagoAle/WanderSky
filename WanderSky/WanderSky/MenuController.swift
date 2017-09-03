//
//  MenuController.swift
//  Challenge 4
//
//  Created by joão gabriel on 14/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class MenuController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    //@IBOutlet weak var optinsView: UIView!
    //@IBOutlet weak var soundButton: UIButton!
    //@IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var stageSelect: UIButton!
    //@IBOutlet weak var continueFocus: UIImageView!
    
    var audioPlayer = AVAudioPlayer()
    static var menuController: MenuController?

    
    override func viewDidLoad() {
        
        MenuController.menuController = self
        
//        musicButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        soundButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        
//        musicButton.layer.borderWidth = 0
        
        let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "musicacristal", ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound as URL)
        }catch{
            print("Error audio Player")
        }
        
        if MenuController.isFirstTime() != 1 {
            MenuController.savePlayerMusicPreference(stage: true)
            MenuController.savePlayerSoundPreference(stage: true)
        }
        
        if MenuController.loadPlayerMusicPreference() == false {
        }else{
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
        
        let initialStage = MenuController.loadHigherStageInNSUserDefault()
        if initialStage == 0{
            setInitialStars()
        }
        
        //Aplicando a funcao de clicar no menu para sair do mune de options
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenOptionMenu))
        tap.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        //self.optinsView.addGestureRecognizer(tap)
        
        
//        if (MenuController.loadPlayerMusicPreference()){
//            musicButton.setBackgroundImage(UIImage(named:"BTNMusic"), for: .normal)
//        }else{
//            musicButton.setBackgroundImage(UIImage(named:"BTNMusicDisabled"), for: .normal)
//        }
//        
//        
//        if (MenuController.loadPlayerSoundPreference()){
//            soundButton.setBackgroundImage(UIImage(named:"BTNSound"), for: .normal)
//        }else{
//            soundButton.setBackgroundImage(UIImage(named:"BTNSoundDisabled"), for: .normal)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let stage = MenuController.loadPlayerStageInNSUserDefault()
        if stage == 0 {
            newGameButton.setTitle("New Game", for: .normal)
        }
    }
    
    @IBAction func continueAct(_ sender: Any) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameView") as! GameViewController
        self.present(gameViewController, animated: true, completion: nil)

    }
  
    
    @IBAction func stageAction(_ sender: Any) {
        let stageSelectController = self.storyboard?.instantiateViewController(withIdentifier: "StageSelect") as! StageSelectController
        self.present(stageSelectController, animated: true, completion: nil)
    }
    
    @IBAction func optionsAction(_ sender: UIButton) {
        //self.optinsView.isHidden = false
    }

    func hiddenOptionMenu() {
        //self.optinsView.isHidden = true
    }
    
    
//    @IBAction func soundAction(_ sender: UIButton) {
//        let preference = MenuController.loadPlayerSoundPreference()
//        MenuController.savePlayerSoundPreference(stage: !preference)
//        if (!preference){
//            soundButton.setBackgroundImage(UIImage(named:"BTNSound"), for: .normal)
//        }else{
//            soundButton.setBackgroundImage(UIImage(named:"BTNSoundDisabled"), for: .normal)
//        }
//    }
    
    
//    @IBAction func musicAction(_ sender: UIButton) {
//        let musicPreference = MenuController.loadPlayerMusicPreference()
//        MenuController.savePlayerMusicPreference(stage: !musicPreference)
//        if (!musicPreference){
//            musicButton.setBackgroundImage(UIImage(named:"BTNMusic"), for: .normal)
//            audioPlayer.prepareToPlay()
//            audioPlayer.numberOfLoops = -1
//            audioPlayer.play()
//        }else{
//            musicButton.setBackgroundImage(UIImage(named:"BTNMusicDisabled"), for: .normal)
//            audioPlayer.pause()
//        }
//    }
    
    
    // Salvar a fase atual que o jogador esta jogando
    static func savePlayerStageInNSUserDefault(stage: Int) {
            UserDefaults.standard.set(stage, forKey: "userStage")
    }
    
    // Carregar a fase atual que o jogador esta jogando
    static func loadPlayerStageInNSUserDefault() -> Int {
        return UserDefaults.standard.integer(forKey: "userStage")
    }
    
    // Carregar a fase mais avancada do jogador
    static func loadHigherStageInNSUserDefault() -> Int {
        return UserDefaults.standard.integer(forKey: "higherUserStage")
    }

    // Savar a fase mais avancada do jogador
    static func savehigherStageInUserDefault(stage: Int){
        if loadHigherStageInNSUserDefault() < stage {
            UserDefaults.standard.set(stage, forKey: "higherUserStage")
        }
    }
    
    
    //--------- MUSICA -------------
    
    // Salvar a preferencia do usuario para a musica de fundo
    static func savePlayerMusicPreference(stage: Bool) {
        UserDefaults.standard.set(stage, forKey: "musicPreference")
    }
    
    // Carregar a preferencia do usuario para a musica de fundo
    static func loadPlayerMusicPreference() -> Bool {
        return UserDefaults.standard.bool(forKey: "musicPreference")
    }
    
    // Salvar a preferencia do usuario para o som
    static func savePlayerSoundPreference(stage: Bool) {
        UserDefaults.standard.set(stage, forKey: "soundPreference")
    }
    
    // Carregar a preferencia do usuario para o som
    static func loadPlayerSoundPreference() -> Bool {
        return UserDefaults.standard.bool(forKey: "soundPreference")
    }
    
    static func isFirstTime() -> Int{
        return UserDefaults.standard.integer(forKey: "firstTime")
    }
    
    static func firstTime(){
        UserDefaults.standard.set(1, forKey: "firstTime")
    }
    
    func countPhases() -> Int{
        let path = Bundle.main.path(forResource: "game", ofType: "json")
        let jsonData : Data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        
        let json = try! JSONSerialization.jsonObject(with: jsonData) as? [String : Any]
        
        return (json?.count)!
    }
    
    func setInitialStars() {
        var dict  = [String:Int]()
        for i in 0...countPhases(){
            dict["fase\(i)"] = 0
        }
        GameLoadManager.writeFile(json: dict)
    }
    
}




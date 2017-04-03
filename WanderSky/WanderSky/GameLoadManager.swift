//
//  GameLoadManager.swift
//  Challenge 4
//
//  Created by Tiago Queiroz on 10/02/17.
//  Copyright © 2017 Italus. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

class GameLoadManager: NSObject {
    
    var json: [String: Any]?
    var obstacles: [Obstacle] = [Obstacle]()
    var stone: StoneModel?
    var stone2: StoneModel?
    var xPlat: Double?
    var yPlat: Double?
    var phase = 3
    static var length:Int?
    var jsonStars = [String:Int]()
    
    //Função que carrega o json e carrega a fase atual
    func configurePhases() {
        let path = Bundle.main.path(forResource: "game", ofType: "json")
        let jsonData : Data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        
        self.json = try! JSONSerialization.jsonObject(with: jsonData) as? [String : Any]
        
        //print("jsonData \(json)")
        self.phase = MenuController.loadPlayerStageInNSUserDefault()
        self.setPhase(indexPhase: self.phase)
        GameLoadManager.length = self.json?.count
        
    }
    
    //Escreve Json de estrelas em um arquivo
    static func writeFile(json: [String:Any]) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        print(documentDirectory)
        if let outputJSON = OutputStream(toFileAtPath: documentDirectory.appending("/stars.json"), append: false)
        {
            outputJSON.open()
            JSONSerialization.writeJSONObject(json, to: outputJSON, options: JSONSerialization.WritingOptions.prettyPrinted, error: nil)
            outputJSON.close()
        }
        
    }
    //Lê json das estrelas
    static func readJsonStars() -> [String:Int] {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        let jsonData : Data = try! Data(contentsOf: URL(fileURLWithPath: documentDirectory.appending("/stars.json")))
        
        let json = try! JSONSerialization.jsonObject(with: jsonData) as? [String : Int]
        
        return json!
    }
    
    //Atualiza a quantidade de estrelas de acordo com o número da fase
    func updateJsonStars(index: Int, stars: Int){
        
        self.jsonStars = GameLoadManager.readJsonStars()
        if self.jsonStars["fase\(index)"]! < stars{
            self.jsonStars["fase\(index)"] = stars
        }
        print("----------\n\n\n\n\n\n")
        for choosenStar in self.jsonStars{
            print(choosenStar)
        }
        
        print("\n\n\n\n\n\n----------")
        GameLoadManager.writeFile(json: self.jsonStars)

    }

    //Seta fase de acordo com o número da fase
    func setPhase(indexPhase : Int) {
            let fase = self.json!["fase\(indexPhase)"] as! [String: Any]
            
            let plataform = fase["plataforms"] as! [String:Any]
            if let obstacles = fase["obstacles"] as? [String:Any]{
                self.configureObstacles(obstacles: obstacles)
            }

            self.configurePlataform(plataform: plataform)
            self.configureCrystal()
            
            let camera = SKCameraNode()
            camera.setScale(2)
            camera.position = CGPoint(x: 281.96, y: 199)
            gameScene?.addChild(camera)
            gameScene?.camera = camera
        
        
    }
    
    //Configura todos os obstáculos das fases
    func configureObstacles(obstacles: [String:Any]) {
        for i in 1...obstacles.count{
            var obs = obstacles["ob\(i)"] as! [String:Any]
            
            let angle = obs["angle"] as! CGFloat
            let color = obs["color"] as! String
            
            let obstacleAux = Obstacle(id: 1, width: obs["width"] as! Double, heigth: obs["height"] as! Double, color: color, type: "perceptron", angle: angle*CGFloat(M_PI/180))
            obstacleAux.node.position = CGPoint(x: obs["positionX"] as! Int, y: obs["positionY"] as! Int)
            
            if (obs["isMoving"] as! Bool){
                obstacleAux.setSpeedDirection(speed: obs["speed"] as! Double, distanceX: obs["distanceX"] as! Double, distanceY: obs["distanceY"] as! Double, velocityRotation: obs["velocityRotation"] as! Double)
            }
            
            gameScene?.addChild(obstacleAux.node)
            
            self.obstacles.append(obstacleAux)
        }
    }
    
    //Cria a plataforma inicial e final através de informações do JSON
    func configurePlataform(plataform: [String:Any]) {
        var platIni = plataform["plat1"] as! [String: Any]
        var platFinal = plataform["plat2"] as! [String:Any]
        
        xPlat = platIni["positionX"] as? Double
        yPlat = platIni["positionY"] as? Double
        
        PlatformModel.addPlatform(platformName: "PlatI", position: CGPoint.init(x: platIni["positionX"] as! Int, y: platIni["positionY"] as! Int), platform: .release)
        PlatformModel.addPlatform(platformName: "PlatF", position: CGPoint.init(x: platFinal["positionX"] as! Int, y: platFinal["positionY"] as! Int), platform: .landing)
        
        
    }
    
    //Seta a posição dos cristais e cria o anjo Arielus
    func configureCrystal() {
        
        let ariel = ArielNode(positionX: xPlat!, positionY: yPlat!+200)
        ariel.name = "ariel"
        gameScene?.addChild(ariel)
        
        self.stone = StoneModel(withVelocity: 10, andClockDirection: false, andColor: .purple, positionX: xPlat!, positionY: yPlat!+200)
        self.stone2 = StoneModel(withVelocity: 5, andClockDirection: true, andColor: .green, positionX: xPlat!, positionY: yPlat!+200)
            
    }
    
//    static func savePhaseStars(stars: Int, index: Int) {
//        UserDefaults.standard.set(stars, forKey: "idPhase\(index)")
//    }
//    
//    static func loadPhaseStars(index: Int) -> Int {
//        return UserDefaults.standard.integer(forKey: "idPhase\(index)")
//    }
    
}

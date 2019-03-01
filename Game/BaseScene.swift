//
//  BaseScene.swift
//  Game
//
//  Created by MacStudent on 2019-03-01.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class BaseScene: SKScene {

    var playButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
         self.playButton = self.childNode(withName: "playButton") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        // Getting the touch
        guard let touch = touches.first  else {
            return
        }
    
        // Getting the touch location
        let mouseLocation = touch.location(in: self)
        
        // detect what sprite was touched
        let spriteTouched = self.atPoint(mouseLocation)
        
        if (spriteTouched.name == "playButton") {
           
            // Now set game run to true
            gameRunning = true
            
            
            // Prepare for rederecting user to game
            guard let scene = GameScene(fileNamed: "GameScene") else {
                return
            }
            
            
            // Redirect to the game
            let skView = self.view! as SKView
            skView.showsPhysics = false
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
       
        }
        
    }
    
    
    
}

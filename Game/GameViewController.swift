//
//  GameViewController.swift
//  Game
//
//  Created by MacStudent on 2019-02-26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = GameScene(fileNamed: "Base") else {
            return
        }
        
        //let scene = GameScene(size:CGSize(width:2048, height:1536))
        let skView = self.view as! SKView
        
        
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

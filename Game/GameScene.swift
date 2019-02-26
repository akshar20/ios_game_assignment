//
//  GameScene.swift
//  Game
//
//  Created by MacStudent on 2019-02-26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // REFERENCE PLAYER TO VARIABLE
    let player = SKSpriteNode(imageNamed: "player")
    
    
    // CANVAS VARIABLES
    var pathArray = [CGPoint]()
    

    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.white
        
        // SETTING UP THE PLAYER
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(player)
    }
    
    
    func touchDown(atPoint pos: CGPoint){
        pathArray.removeAll()
        pathArray.append(pos)
    }
    
    func touchMoved(toPoint pos: CGPoint){
        pathArray.append(pos)
    }
    
    func touchUp(atPoint pos: CGPoint){
        createLine()
    }
    
    // GENERATING A LINE
    func  createLine() {
        
        let path = CGMutablePath()
        path.move(to: pathArray[0])
        
        // Adding points into array
        for point in pathArray{
            path.addLine(to: point)
        }
        
        
        // Adding line to screen
        let line = SKShapeNode()
        line.path = path
        line.fillColor = .clear
        line.lineWidth = 2
        line.strokeColor = .cyan
        line.lineCap = .round
        line.glowWidth = 20
        self.addChild(line)
        
        
        // Fade out line
        let fed:SKAction = SKAction.fadeOut(withDuration: 1)
        fed.timingMode = .easeIn
        let remove:SKAction = SKAction.removeFromParent()
        line.run(SKAction.sequence([fed,remove]))
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchMoved(toPoint: t.location(in: self))}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchUp(atPoint: t.location(in: self))}
    }
}








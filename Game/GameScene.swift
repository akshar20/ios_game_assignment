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
        
        
        // Double Tap Recognizer
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTap(_:)))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGR)
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
        
       
        // Recognize Shape
        recognizePath()
        //print("Start: \(pathArray[0])   End: \(pathArray[pathArray.count - 1])")
        
     
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
    
    
    
    // RECOGNIZE PATH
    func recognizePath(){
        
        // Starting and ending points
        let x1 = Double(round(1000*self.pathArray[0].x)/1000)
        let y1 = Double(round(1000*self.pathArray[0].y)/1000)

        let midy = Double(round(1000*self.pathArray[pathArray.count/2-1].y)/1000)
        
        let x2 = Double(round(1000*self.pathArray[pathArray.count - 1].x)/1000)
        let y2 = Double(round(1000*self.pathArray[pathArray.count - 1].y)/1000)
        
        
        // Check for horizontal and vertical line
        var differenceX = x1 - x2
        var differenceY = y1 - y2
        // If difference is in negative then convert it into positive
        if(differenceX < 0){
            differenceX *= -1
        }
        
        if(differenceY < 0){
            differenceY *= -1
        }
        
    
        
        // Checking for triangles (Condition: upper/lower corner of triangle has to be 25% of grater/lower)
        if(midy > y1 && midy > y2){
            if(midy > (y2 + (y2*0.25))){
                print("PREDICTED: Upper Triangle ^")
                
            }
            
        }else if(midy < y1 && midy < y2){
            if(midy < (y2 + (y2*0.25))){
                print("PREDICTED: Lower Triangle _")
            }
        
            
        // Checking for lines
        }else{
            if(differenceX > differenceY){
                print("PREDICTED: Horizontal Line --")
                
            }else if(differenceX <= differenceY){
                print("PRIDICTED: Verticle Line |")
                
            }
        }
        
        
    }
}


extension GameScene: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
    }
}






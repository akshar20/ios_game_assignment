//
//  GameScene.swift
//  Game
//
//  Created by MacStudent on 2019-02-26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    // GAME SPRITES VARIABLES
    var monsterSpeed = 0.8
    var monsters:[SKSpriteNode] = []
    var monsterShapes:[SKSpriteNode] = []
    var shapes:[String] = ["hline", "vline", "upperBoom", "lowerBoom"]
    var player = SKSpriteNode()
    
    
    // CANVAS VARIABLES
    var pathArray = [CGPoint]()
    
    
    // TIME TRACKING VARIABLES
    private var lastUpdateTime : TimeInterval = 0
    

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
     
        // Background
        backgroundColor = UIColor.white
        
        
        // Get player reference
        self.player = self.childNode(withName: "player") as! SKSpriteNode
        self.player.constraints = [SKConstraint.positionX(SKRange(lowerLimit: 667, upperLimit: 191.531))]
        
        
        // Double Tap Recognizer
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTap(_:)))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGR)
    }

    
    //************************************************************************************************
    //******************************** CANVAS CODE STARTS ********************************************
    //************************************************************************************************
    
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
     
        // Fade out line
        let fed:SKAction = SKAction.fadeOut(withDuration: 1)
        fed.timingMode = .easeIn
        let remove:SKAction = SKAction.removeFromParent()
        line.run(SKAction.sequence([fed,remove]))
        
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
                print("PREDICTED: Upper Triangle")
                
            }
            
        }else if(midy < y1 && midy < y2){
            if(midy < (y2 + (y2*0.25))){
                print("PREDICTED: Lower Triangle")
            }
        
            
        // Checking for lines
        }else{
            if(differenceX > differenceY){
                print("PREDICTED: Horizontal Line")
                
            }else if(differenceX <= differenceY){
                print("PRIDICTED: Verticle Line")
                
            }
        }
        
        
    }
    
    
    //**********************************************************************************************
    //******************************** CANVAS CODE ENDS ********************************************
    //**********************************************************************************************
    
    
    
    
    
    // TOUCH RECOGNIZER
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchMoved(toPoint: t.location(in: self))}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchUp(atPoint: t.location(in: self))}
    }
    
    
    
    
    
    
    // COLLISION
    func didBegin(_ contact: SKPhysicsContact) {
        
        let node1 = contact.bodyA.node
        let node2 = contact.bodyB.node
        
        // Check for hit
        if(node1?.name == "player" || node2?.name == "player"){
            print("Collision Detected")
        }
    }
    
    
    // Add Monster
    func addMonster(){
      
        // generate a random (x,y) position for the monster
        var randomX = arc4random_uniform(UInt32(size.width))
        let randomY = arc4random_uniform(UInt32(size.height))
        
        while ((randomX > UInt32((self.size.width/2 - 250))) && (randomX < UInt32((self.size.width/2 + 250)))) {
            randomX = arc4random_uniform(UInt32(size.width))
        }
        
        // load the monster image
        var monster = SKSpriteNode()
        
        if(randomX > UInt32(self.size.width/2)){
            monster = SKSpriteNode(imageNamed: "monster_right")
        }else{
            monster = SKSpriteNode(imageNamed: "monster_left")
        }
        
        monster.position = CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
        monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: monster.size.width, height: monster.size.height))
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.allowsRotation = false
        
        
        // put monster on screen
        addShapeToMonster(mons: monster)
        addChild(monster)
        
        self.monsters.append(monster)
    }
    
    
    // Add Shape To Monster
    func addShapeToMonster(mons: SKSpriteNode){
        
        
    }
    
    
    
    
    // UPDATE THINGS
    override func update(_ currentTime: TimeInterval) {
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // HINT: This code prints "Hello world" every 5 seconds
        if (dt > 5) {
            self.addMonster()
            self.lastUpdateTime = currentTime
        }
        
        
        // Monster follows player
        let location = self.player.position
        
        for mons in self.monsters {
            //Aim
            let dx = (location.x) - mons.position.x
            let dy = (location.y) - mons.position.y
            let angle = atan2(dy, dx)
            
            mons.zRotation = angle - 3 * .pi/2
            
            //Seek
            let velocityX = cos(angle) * CGFloat(self.monsterSpeed)
            let velocityY = sin(angle) * CGFloat(self.monsterSpeed)
            
            mons.position.x += velocityX
            mons.position.y += velocityY
        }
        
    }
    
    
}


extension GameScene: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
    }
}






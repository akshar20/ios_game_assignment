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
    var scoreLabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    var monsterSpeed = 1.4
    var monsters_shape = [String: SKShapeNode]()
    var monsters_body = [String: SKSpriteNode]()
    var monsterShapes:[SKSpriteNode] = []
    var shapes:[String] = ["hLine", "vLine", "upperBoom", "lowerBoom"]
    var player = SKSpriteNode()
    
    
    
    // CANVAS VARIABLES
    var pathArray = [CGPoint]()
    
    
    // TIME TRACKING VARIABLES
    private var lastUpdateTime : TimeInterval = 0

    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
     
        // BACKGROUND MUSIC
        let backSound = SKAction.playSoundFileNamed("backgroundMusic", waitForCompletion: false)
        run(backSound)
        

        
        // Game Stats Reference
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        self.livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        
        
        if(gameScore < 10){
            self.scoreLabel.text = "0\(gameScore)"
        }else{
            self.scoreLabel.text = "\(gameScore)"
        }
       
        if(gameLives < 10){
            self.livesLabel.text = "0\(gameLives)"
        }else{
            self.livesLabel.text = "\(gameLives)"
        }
        
        
        // Get player reference
        self.player = self.childNode(withName: "player") as! SKSpriteNode
        self.player.constraints = [SKConstraint.positionX(SKRange(lowerLimit: 667, upperLimit: 191.531))]
        
        
        
        //************************************************************
        //****************** TEMP CODE *******************************
        //************************************************************
        
        
        
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
                //print("PREDICTED: Upper Boomerang")
                
                // Remove Monster Shape
                for (key, val) in self.monsters_shape{
                    
                    if(key == "upperBoom"){
                    
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        val.run(sequence)
                    }
                }
                
                // Remove Monster Body
                for (key, val) in self.monsters_body{
                    
                    if(key == "upperBoom"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                      
                        val.run(sequence)
                    }
                }
                
                // Remove Monster from Dictionary
                self.monsters_shape.removeValue(forKey: "upperBoom")
                self.monsters_body.removeValue(forKey: "upperBoom")
                
                // Increase Game Score
                increaseGameScore()
               
            }
            
        }else if(midy < y1 && midy < y2){
            if(midy < (y2 + (y2*0.25))){
                //print("PREDICTED: Lower Boomerangs")
                
                // Remove Monster Shape
                for (key, val) in self.monsters_shape{
                    
                    if(key == "lowerBoom"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        val.run(sequence)
                    }
                }
                
                // Remove Monster Body
                for (key, val) in self.monsters_body{
                    
                    if(key == "lowerBoom"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        
                        val.run(sequence)
                    }
                }
                
                // Remove Monster from Dictionary
                self.monsters_shape.removeValue(forKey: "lowerBoom")
                self.monsters_body.removeValue(forKey: "lowerBoom")
                
                
                // Increase Game Score
                increaseGameScore()
            }
        
            
        // Checking for lines
        }else{
            if(differenceX > differenceY){
                //print("PREDICTED: Horizontal Line")
                
                
                // Remove Monster Shape
                for (key, val) in self.monsters_shape{
                    
                    if(key == "hLine"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        val.run(sequence)
                    }
                }
                
                // Remove Monster Body
                for (key, val) in self.monsters_body{
                    
                    if(key == "hLine"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        
                        val.run(sequence)
                    }
                }
                
                // Remove Monster from Dictionary
                self.monsters_shape.removeValue(forKey: "hLine")
                self.monsters_body.removeValue(forKey: "hLine")
                
                // Increase Game Score
                increaseGameScore()
                
            }else if(differenceX <= differenceY){
                //print("PRIDICTED: Verticle Line")
                
                // Remove Monster Shape
                for (key, val) in self.monsters_shape{
                    
                    if(key == "vLine"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        val.run(sequence)
                    }
                }
                
                // Remove Monster Body
                for (key, val) in self.monsters_body{
                    
                    if(key == "vLine"){
                        
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                        let remove        = SKAction.run({ val.removeFromParent }())
                        let sequence      = SKAction.sequence([fadeOutAction, remove])
                        
                        val.run(sequence)
                    }
                }
                
                // Remove Monster from Dictionary
                self.monsters_shape.removeValue(forKey: "vLine")
                self.monsters_body.removeValue(forKey: "vLine")
                
                
                // Increase Game Score
                increaseGameScore()
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
    
    
    
    
    // *********** *********** *********** *********** *********** *********** ***********
    //  ********* GAME CORE FUNCTIONS (WIN, LOSE, RESTART, MOVE TO NEXT LEVEL)  **********
    // *********** *********** *********** *********** *********** *********** ***********
    
    
    // INCREASES GAME SCORE BY 1
    func increaseGameScore(){
        gameScore += 1
        
        if(gameScore < 10){
            self.scoreLabel.text = "0\(gameScore)"
        }else{
            self.scoreLabel.text = "\(gameScore)"
            
            // Game Over scene
            let scene = SKScene(fileNamed: "GameWin")!
            let transition = SKTransition.flipVertical(withDuration: 2)
            self.view?.presentScene(scene, transition: transition)
            
        }
    }
    
    
    
    @objc func restartGame() {
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = scaleMode
        view?.presentScene(scene)
    }
    
    
    // *********** *********** *********** *********** *********** *********** ***********
    //  ***** GAME CORE FUNCTIONS (WIN, LOSE, RESTART, MOVE TO NEXT LEVEL)  ENDS *********
    // *********** *********** *********** *********** *********** *********** ***********
    
    
    
    
    
    
    // COLLISION
    func didBegin(_ contact: SKPhysicsContact) {
        
        let node1 = contact.bodyA.node
        let node2 = contact.bodyB.node
        
        // Check for hit
        if(node1?.name == "player" || node2?.name == "player"){
            
            
            // Restart the game
            gameLives -= 1
            if(gameLives > 0){
                
                if(gameLives < 10){
                    self.livesLabel.text = "0\(gameLives)"
                }else{
                    self.livesLabel.text = "\(gameLives)"
                }
                
                let msg = SKLabelNode(text: "Oops... Be Careful!")
                msg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                msg.fontSize = 120
                msg.fontName = "Noteworthy-Bold"
                msg.fontColor = UIColor.cyan
                addChild(msg)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.restartGame()
                })
            }else{
                    // Game Over scene
                    let scene = SKScene(fileNamed: "GameOver")!
                    let transition = SKTransition.flipVertical(withDuration: 2)
                    self.view?.presentScene(scene, transition: transition)
            }
            
            
            
            
            
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
    }
    
    
    // Add Shape To Monster
    func addShapeToMonster(mons: SKSpriteNode){
    
        
        let randShape = self.shapes.randomElement()! as String
        
        
        if(randShape == "hLine"){
            
            let start = CGPoint(x: mons.position.x - 100, y: mons.position.y + 50)
            let end = CGPoint(x: mons.position.x + 100, y:mons.position.y + 50)
            
            let hLine = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: start)
            pathToDraw.addLine(to: end)
            hLine.path = pathToDraw
            hLine.strokeColor = SKColor.green
            hLine.lineWidth = 20
            hLine.glowWidth = 1.0
            hLine.name = "shape"
            hLine.physicsBody?.isDynamic = true
            addChild(hLine)
            addChild(mons)
            
            
            // Adding shape and monster to array
            self.monsters_shape[randShape] = hLine
            self.monsters_body[randShape] = mons
        
        }else if(randShape == "vLine"){
            
            let start = CGPoint(x: mons.position.x, y: mons.position.y + 50)
            let end = CGPoint(x: mons.position.x, y:mons.position.y + 200)
            
            let vLine = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: start)
            pathToDraw.addLine(to: end)
            vLine.path = pathToDraw
            vLine.strokeColor = SKColor.red
            vLine.lineWidth = 20
            vLine.glowWidth = 1.0
            vLine.name = "shape"
            vLine.physicsBody?.isDynamic = true
            addChild(vLine)
            addChild(mons)
            
            
            // Adding shape and monster to array
            self.monsters_shape[randShape] = vLine
            self.monsters_body[randShape] = mons
            
            
        }else if(randShape == "upperBoom"){
            
            
            let start = CGPoint(x: mons.position.x, y: mons.position.y)
            let mid = CGPoint(x: mons.position.x + 100, y: mons.position.y + 50)
            let end = CGPoint(x: mons.position.x + 200, y: mons.position.y - 50)
            
            let path = CGMutablePath()
            path.move(to: start)
            path.addLine(to: mid)
            path.addLine(to: end)
            
            let upperB = SKShapeNode()
            upperB.path = path
            upperB.strokeColor = UIColor.magenta
            upperB.lineWidth = 20
            upperB.glowWidth = 1.0
            upperB.physicsBody?.isDynamic = true
            addChild(upperB)
            addChild(mons)
            
            
            // Adding shape and monster to array
            self.monsters_shape[randShape] = upperB
            self.monsters_body[randShape] = mons
            
        }else if(randShape == "lowerBoom"){
            
            let start = CGPoint(x: mons.position.x, y: mons.position.y)
            let mid = CGPoint(x: mons.position.x + 100, y: mons.position.y - 50)
            let end = CGPoint(x: mons.position.x + 200, y: mons.position.y + 50)
            
            let path = CGMutablePath()
            path.move(to: start)
            path.addLine(to: mid)
            path.addLine(to: end)
            
            let lowerB = SKShapeNode()
            lowerB.path = path
            lowerB.strokeColor = UIColor.purple
            lowerB.lineWidth = 20
            lowerB.glowWidth = 1.0
            lowerB.physicsBody?.isDynamic = true
            addChild(lowerB)
            addChild(mons)
            
            
            // Adding shape and monster to array
            self.monsters_shape[randShape] = lowerB
            self.monsters_body[randShape] = mons
            
        }
        
        
        
        
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
        if (dt > 3) {
            self.addMonster()
            self.lastUpdateTime = currentTime
        }
        
        
        // Monster follows player
        let location = self.player.position
        
        // Move monster
        for (key,mons_body) in self.monsters_body {
            //Aim
            let dx = (location.x) - mons_body.position.x
            let dy = (location.y) - mons_body.position.y
            let angle = atan2(dy, dx)
            
            mons_body.zRotation = angle - 3 * .pi/2
            
            //Seek
            let velocityX = cos(angle) * CGFloat(self.monsterSpeed)
            let velocityY = sin(angle) * CGFloat(self.monsterSpeed)
            
            self.monsters_shape[key]?.position.x += velocityX
            self.monsters_shape[key]?.position.y += velocityY
            
            mons_body.position.x += velocityX
            mons_body.position.y += velocityY
        }
        
    }
    
    
}


extension GameScene: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
    }
}






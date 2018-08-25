//
//  GameScene.swift
//  Project20
//
//  Created by Charles Martin Reed on 8/24/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK:- Class properties
    var gameTimer: Timer!
    var scoreLabel: SKLabelNode!
    var fireworks = [SKNode]() //will have container, image and fuse nodes
    
    //our fireworks will launch right off the screen to a particular side
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //game control properties
    var launchCounter = 0
    let rounds = 5
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left //this sets the text to the far left of the node's origin point
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        //we will create a Timer that launches fireworks every 6 seconds
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
       
    }
    
    //MARK:- Creating and launching our fireworks
    //needs to accept a movement speed for the firework, and its X and Y positions
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        
        //create SKNode to act as the fireworks container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //create a rocket sprite node and name it "firework". Adjust its colorBlendFactor so that we can color it. Add the sprite to the container node.
        //since our rocket is actually white, when we set colorBlendFactor to 1, it'll actually take the color generated by our random generator below
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 //describes how color is blended with obj texture
        firework.name = "firework"
        node.addChild(firework)
        
        //give the firework sprite node one of three random colors, cyan red or green.
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
            
        default:
            break
        }
        
        //create a UIBezierPath that will represent the movement of the firework
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        //Tell the container node to follow that path using .follow action, turning itself as needed by setting orientToPath and asOffset to true
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //Create particles behind the rocket to make it look like the fireworks are lit
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        //add the firework to our fireworks array AND add the container to the scene
        fireworks.append(node)
        addChild(node)
        
    }
    
    //calls createFirework in order to spread out the fireworks on screen
   @objc func launchFireworks() {
    //using a launch counter to limit launches to 5
        let movementAmount: CGFloat = 1800
    
    if launchCounter < rounds {
        
        //upperBound of 4 because we're generating 5 rockets
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
            
        //fire the five rockets straight up
        case 0:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            //fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            //fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            //fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
        launchCounter += 1
        
    } else {
        //when the launchCounter reaches the rounds limit, stop the timer and end the game
        
            gameTimer.invalidate()
            gameOver()
        }
    
    }
    
    //MARK:- Handling touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        //figure out where in the scene the player touches and what nodes are at that point
        //loop through the nodes under the point to find any with the name "firework".
        //If found, change name to "selected" and colorBlendFactor to 0, which will make the rocket white again.
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node is SKSpriteNode {
                let sprite = node as! SKSpriteNode
                
                if sprite.name == "firework" {
            
                    //we'll need an inner loop here to ensure that we only allow selection of similarly colored fireworks
                    for parent in fireworks {
                        let firework = parent.children[0] as! SKSpriteNode
                        
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name = "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    sprite.name = "selected"
                    sprite.colorBlendFactor = 0
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                //uses a high position above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    //MARK:- Making explosions in the sky
    func explode(firework: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "explode")!
        emitter.position = firework.position
        addChild(emitter)
        
        firework.removeFromParent()
    }
    
    //loop through fireworks array backwards to try to head off any out of bounds issues, pick out the selected fireworks and call explode on them
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            let firework = fireworkContainer.children[0] as! SKSpriteNode
            
            //remember we're exploding the entire container, not just the rocket/firework node
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        //scaling our score according to how many fireworks of the same color the user chooses
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    func gameOver() {
        
        //show the gameOver label
        let gameOverLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = UIColor.red
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        scoreLabel.zPosition = 2
        addChild(gameOverLabel)
        
        //set the launch counter back to 0
        launchCounter = 0
    }
}

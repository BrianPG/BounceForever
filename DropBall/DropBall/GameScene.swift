//
//  GameScene.swift
//  DropBall
//
//  Created by Brian Griffin on 10/12/17.
//  Copyright © 2017 briang. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// Added new contact delegate to monitor and control collisions

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var player = AVAudioPlayer()
    var fxPlayer = AVAudioPlayer()
    

    // Create ball node
    var ball = SKSpriteNode()
    var puke = SKSpriteNode()
    var gameOver = false
    var gameOverLabel = SKLabelNode()
    
    var scoreLabel = SKLabelNode()
    var score = 0;
    
    enum ColliderType: UInt32 {
        
        case Ball = 1
        case RightWall = 2
        case LeftWall = 4
        case Pad = 8
        //case Ice = 32
        case Object = 14
        case Ground = 16
        
    }
    func animateBounceWithSound() {
        
        // Give balltexture an image
        // And apply to ball
        let ballTexture = SKTexture(imageNamed: "balleyez.png")
        let ballTexture2 = SKTexture(imageNamed: "ball2eyez.png")
        let ballTexture3 = SKTexture(imageNamed: "ball3eyez.png")
        let pukeTexture = SKTexture(imageNamed: "ballpuke.png")
        
        puke = SKSpriteNode(texture: pukeTexture)
        
        //Animate ball bounce
        let bounceAnimation = SKAction.animate(with: [ballTexture,ballTexture2,ballTexture3], timePerFrame: 0.1)
        let bounceForever = SKAction.repeat(bounceAnimation, count: 1)//ie Not forever...
        ball.run(bounceForever)
        
        let fileLocal = Bundle.main.path(forResource: "low_boing", ofType: "mp3")
        
        do {
            try fxPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocal!))
            
            fxPlayer.volume = 0.6
            
            fxPlayer.play()
        } catch {
            // process error
        }
        

        
    }

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        let fileLocal = Bundle.main.path(forResource: "call_it_a_day", ofType: "mp3")
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocal!))
            
            player.volume = 0.5
            
            player.play()
        } catch {
            // process error
        }

        
        setupGame()
        
           }
   
    
    
    func setupGame() {
        self.backgroundColor = UIColor.white
        
        
        
        // Give balltexture an image
        
        let ballTexture = SKTexture(imageNamed: "balleyez.png")
        
        
        
        
        ball = SKSpriteNode(texture: ballTexture)
        
        
        //Apply physics to ball
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        
        
        // Give ball a position
        // Add ball to scene and apply animation
        ball.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        
        self.addChild(ball)
        //ball.run(bounceForever)
        
        // make physics dynamic only after player touches screen
        // this will apply gravity
        // Set velocity to zeros before applying impulse
        ball.physicsBody!.isDynamic = false
        
        // simulate physical bounce of ball in both with impulse in both
        // x and y direction
        ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody!.restitution = 0.4
        
        ball.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ball.physicsBody!.categoryBitMask = ColliderType.Ball.rawValue
        ball.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        
        let ground = SKNode()
        let ceiling = SKNode()
        let leftWall = SKNode()
        let rightWall = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height/2)
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.height/2)
        leftWall.position = CGPoint(x:-self.frame.width/2, y: self.frame.midY)
        rightWall.position = CGPoint(x:self.frame.width/2, y: self.frame.midY)
        
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height:1))
        ceiling.physicsBody!.isDynamic = false
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        leftWall.physicsBody!.isDynamic = false
        rightWall.physicsBody!.isDynamic = false
        
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Ground.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Ground.rawValue
        leftWall.physicsBody!.contactTestBitMask = ColliderType.LeftWall.rawValue
        rightWall.physicsBody!.contactTestBitMask = ColliderType.RightWall.rawValue
        
        
        
        
        self.addChild(ground)
        self.addChild(ceiling)
        self.addChild(rightWall)
        self.addChild(leftWall)
        
        scoreLabel.fontName = "AmericanTypeWriter-Bold"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 70)
        
        self.addChild(scoreLabel)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            ball.physicsBody!.isDynamic = true
            let bouncePad = SKSpriteNode(imageNamed: "bouncePad1.png")
            //let icePad = SKSpriteNode(imageNamed: "ice_bounce_Pad.")
        

            
            for touch in touches {
                let local = touch.location(in: self)
                
            
                bouncePad.position = local
                bouncePad.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
                bouncePad.physicsBody!.isDynamic = false
                self.addChild(bouncePad)
                
            }
        
        
            bouncePad.physicsBody!.contactTestBitMask = ColliderType.Pad.rawValue
        
            bouncePad.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.fadeOut(withDuration: 0.5),SKAction.removeFromParent()]))
        
        
        
        } else {
            gameOver = false
            
            score = 0;
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
        }
        
           }
    func didBegin(_ contact: SKPhysicsContact) {
        
        var ballMovementX = 0;
        var ballMovementY = 0;
       
        
        if contact.bodyA.contactTestBitMask == ColliderType.Pad.rawValue {
            score += 1
            scoreLabel.text = String(score)
            ballMovementX = Int(arc4random_uniform(UInt32(6 - (-6))))
            ballMovementY = 12
        }
        if contact.bodyA.contactTestBitMask == ColliderType.LeftWall.rawValue {
            self.backgroundColor = UIColor.green
            ballMovementX = 4
            ballMovementY = 0
        }
        if contact.bodyA.contactTestBitMask == ColliderType.RightWall.rawValue {
            self.backgroundColor = UIColor.red
            ballMovementX = -4
            ballMovementY = 0
        }
        if contact.bodyA.categoryBitMask == ColliderType.Ground.rawValue {
            self.speed = 0
            
            gameOver = true
            
            gameOverLabel.fontName = "AmericanTypewriter-Bold"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Game Over! Try Again?"
            gameOverLabel.fontColor = UIColor.black
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
            
        }
        
        
        
        if score >= 15 {
            ball.physicsBody!.restitution = 0.6

        }
        if score >= 25 {
            ball.physicsBody!.restitution = 0.8
            
        }
        if score >= 35 {
            ball.physicsBody!.restitution = 0.99
            
        }
        
        
        
       
        
        
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: ballMovementX, dy: ballMovementY ))
        self.animateBounceWithSound()
        
        

    
    }
    
       
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

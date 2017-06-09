//
//  CaughtScene.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import SpriteKit
import UIKit

class CaughtScene: SKScene, SKPhysicsContactDelegate {
    var monster: Monster!
    var monsterSprite: SKNode!
    var webSprite: SKNode!
    let kMonsterSize: CGSize = CGSize(width: 128, height: 128)
    let kMonsterName: String = "monster"
    let kWebSize: CGSize = CGSize(width: 200, height: 200)
    let kWebName: String = "web"
    let monsterMoveDistance = 150.0
    let monsterMovePixelsPerSecond = 70.0
    let kMonsterCategory: UInt32 = 0x1 << 0
    let kWebCategory: UInt32 = 0x1 << 1
    let kSceneEdgeCategory: UInt32 = 0x1 << 2
    var velocity: CGPoint = CGPoint.zero
    var touchPoint: CGPoint = CGPoint()
    var canThrowWeb = false
    var monsterCaught = false
    var startCount = true
    var maxTime = 10
    var myTime = 10
    var printTime = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
        printTime.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        addChild(printTime)
        showMessage(messageString: "¡Atrápalo ahora!")
        perform(#selector(setupMonster), with: nil, afterDelay: 1.0)
        perform(#selector(setupWeb), with: nil, afterDelay: 1.0)
        physicsBody = SKPhysicsBody(edgeLoopFrom:self.frame)
        physicsBody!.categoryBitMask = kSceneEdgeCategory
        physicsWorld.contactDelegate = self
    }
    
    func createMonster() -> SKNode {
        let monsterSprite = SKSpriteNode(imageNamed: monster.imageFileName!)
        monsterSprite.size = kMonsterSize
        monsterSprite.name = kMonsterName
        return monsterSprite
    }
    
    func setupMonster() {
        monsterSprite = createMonster()
        monsterSprite.position =  CGPoint(x: self.size.width/2, y: self.size.height/2 + 150)
        
        monsterSprite.physicsBody = SKPhysicsBody(circleOfRadius: monsterSprite.frame.size.width/3)
        monsterSprite.physicsBody!.isDynamic = false
        monsterSprite.physicsBody!.affectedByGravity = false
        monsterSprite.physicsBody!.mass = 1.0
        
        monsterSprite.physicsBody!.categoryBitMask = kMonsterCategory
        monsterSprite.physicsBody!.contactTestBitMask = kWebCategory
        monsterSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        let moveRight = SKAction.moveBy(x: CGFloat(monsterMoveDistance), y: 0, duration: monsterMoveDistance/monsterMovePixelsPerSecond)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        monsterSprite.run(SKAction.repeatForever(sequence))
        addChild(monsterSprite)
    }
    
    func createWeb() -> SKNode {
        let webSprite = SKSpriteNode(imageNamed: "web")
        webSprite.size = kWebSize
        webSprite.name = kWebName
        return webSprite
    }
    
    func setupWeb() {
        webSprite = createWeb()
        webSprite.position =  CGPoint(x: self.size.width/2, y: 50)
        
        let kWebLevelSize: CGSize = CGSize(width: CGFloat(webSprite.frame.size.width/CGFloat(monster.level)) , height: CGFloat(webSprite.frame.size.height/CGFloat(monster.level)))
        webSprite.physicsBody = SKPhysicsBody(circleOfRadius: kWebLevelSize.width/3)
        webSprite.physicsBody!.isDynamic = true
        webSprite.physicsBody!.affectedByGravity = true
        webSprite.physicsBody!.mass = 0.3
        
        webSprite.physicsBody!.categoryBitMask = kWebCategory
        webSprite.physicsBody!.contactTestBitMask = kMonsterCategory
        webSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory | kMonsterCategory
        
        addChild(webSprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        if webSprite.frame.contains(location!) {
            canThrowWeb = true
            touchPoint = location!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        touchPoint = location!
        if canThrowWeb {
            throwWeb()
        }
    }
    
    func throwWeb() {
        canThrowWeb = false
        let differentialTime: CGFloat = 1.0/30.0
        let distance = CGVector(dx: touchPoint.x - webSprite.position.x, dy: touchPoint.y - webSprite.position.y)
        let velocity = CGVector(dx: distance.dx / differentialTime, dy: distance.dy / differentialTime)
        webSprite.physicsBody!.velocity = velocity
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case kMonsterCategory|kWebCategory:
            monsterCaught = true
            printTime.isHidden = true
            endGame()
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if startCount {
            maxTime = Int(currentTime) + maxTime
            startCount = false
        }
        if myTime > 0 {
            myTime = maxTime - Int(currentTime)
            printTime.text = "\(myTime)"
        } else {
            printTime.isHidden = true
            endGame()
        }
    }
    
    func endGame() {
        monsterSprite.removeFromParent()
        webSprite.removeFromParent()
        if monsterCaught {
            monster.timesCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            showMessage(messageString: "¡Atrapado!")
        } else {
            showMessage(messageString: "¡El \(monster.name!) escapó!")
        }
        perform(#selector(endCaugth), with: nil, afterDelay: 1.0)
    }
    
    func showMessage(messageString: String) {
        let message = SKLabelNode(fontNamed: "AvenirNext-Bold")
        message.text = messageString
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(message)
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
    func endCaugth() {
        NotificationCenter.default.post(name: NSNotification.Name("closeCaught"), object: nil)
    }
}

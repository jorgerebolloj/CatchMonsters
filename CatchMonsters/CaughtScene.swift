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
    let kWebSize: CGSize = CGSize(width: 600/2, height: 597/2)
    let kMonsterName: String = "monster"
    let kWebName: String = "web"
    let monsterMoveDistance = 150.0
    let monsterMovePixelsPerSecond = 70.0
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.size = self.size
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
        perform(#selector(setupMonster), with: nil, afterDelay: 1.0)
        perform(#selector(setupWeb), with: nil, afterDelay: 1.0)
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
        
        addChild(webSprite)
    }
}

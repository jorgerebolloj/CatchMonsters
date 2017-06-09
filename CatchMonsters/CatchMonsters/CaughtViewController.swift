//
//  CaughtViewController.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit
import SpriteKit

class CaughtViewController: UIViewController {
    var monster: Monster!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = CaughtScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.scaleMode = .aspectFill
        scene.monster = self.monster
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToMapViewController), name: NSNotification.Name("closeCaught"), object: nil)
    }
    
    func returnToMapViewController() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

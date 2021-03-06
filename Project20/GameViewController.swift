//
//  GameViewController.swift
//  Project20
//
//  Created by Charles Martin Reed on 8/24/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Shaking to destroy our fireworks
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        //default view controller doesn't know it has a SpriteKit view or the scene that is in that view, so we do some typecasting
        let skView = view as! SKView
        let gameScene = skView.scene as! GameScene
        gameScene.explodeFireworks()
    }
}

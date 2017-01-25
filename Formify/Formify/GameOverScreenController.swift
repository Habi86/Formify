//
//  GameOverScreen.swift
//  Formify
//
//  Created by Vera Karl on 13/06/16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScreen: UIViewController {
    
    let gameover :SKLabelNode = SKLabelNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameOverScene = view as! SKView
        // sceneView.showsFPS = true
        // sceneView.showsNodeCount = true
        gameOverScene.ignoresSiblingOrder = true
        
        let gameover = GameOverScreen(size: view.bounds.size)
        gameover.scaleMode = .ResizeFill
        gameover.presentScene(gameover) 
        
    }
}

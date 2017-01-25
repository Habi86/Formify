//
//  GameViewController.swift
//  Formify
//
//  Created by Vera Karl on 26/01/16.
//  Copyright (c) 2016 FH Salzburg. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var gameScene : GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /* Set the scale mode to scale to fit the window */
        if (self.gameScene != nil) {
            self.gameScene!.scaleMode = .aspectFill
            self.gameScene!.size = self.view.bounds.size
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Configure the view.
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        self.gameScene = GameScene()
        self.gameScene!.viewController = self
        self.gameScene!.scaleMode = .aspectFill
        self.gameScene!.size = self.view.bounds.size
        skView.presentScene(self.gameScene!)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
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

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func changeView() {
        self.performSegue(withIdentifier: "gameover", sender: nil)
        //addSubscription.categoryText = self.category
    }

}




    


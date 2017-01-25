//
//  MenuScene.swift
//  Formify
//
//  Created by Vera Karl on 26/01/16.
//  Copyright (c) 2016 FH Salzburg. All rights reserved.
//


//Startscreen - Formify
import SpriteKit
import UIKit

class MenuScene: SKScene {
    
    let menu:SKLabelNode = SKLabelNode()

    override func didMove(to view: SKView) {
        menu.text = "Formify"
        menu.fontColor = UIColor.white
        menu.fontSize = CGFloat(50)
        menu.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        menu.name = "title" //Zugriff und start der Transition durch name
        addButtons()
        //openHomeScreen()
    }
    
    fileprivate func addButtons() {
        self.addChild(menu)
    }
    
   /* private func openHomeScreen() {
        let homeScreen = HomeScreen(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(5.0)
        view!.presentScene(homeScreen, transition: transition)
        //self.performSegueWithIdentifier("HomeScreen", sender: self)
       // self.scene?.removeFromParent()
    }
*/

}

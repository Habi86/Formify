//
//  GameScene.swift
//  Formify
//
//  Created by Vera Karl on 26/01/16.
//  Copyright (c) 2016 FH Salzburg. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class GameScene: SKScene {
    var sceneSize = CGSize(width:0, height:0)
    var width:CGFloat = 0.0
    var borderWidth:CGFloat = 0.0
    var squareNum = 0
    var squareSize:CGSize = CGSize(width: 0, height:0)
    var viewController : GameViewController!
    
    var scoreLabel: SKLabelNode!
    var score = 20
    var playerBG : AVAudioPlayer!
    var playerSingleSquarePop : AVAudioPlayer!
    var playerGameOver : AVAudioPlayer!
    var playerFormPop : AVAudioPlayer!
    
    //lightred, darkred, lightblue, darkblue, lightgreen
    let colors = [
        UIColor(red: 253/255.0, green: 107/255.0, blue: 106/255.0, alpha: 1.0),
        UIColor(red: 184/255.0, green: 73/255.0, blue: 84/255.0, alpha: 1.0),
        UIColor(red: 78/255.0, green: 205/255.0, blue: 196/255.0, alpha: 1.0),
        UIColor(red: 85/255.0, green: 99/255.0, blue: 112/255.0, alpha: 1.0),
        UIColor(red: 199/255.0, green: 244/255.0, blue: 101/255.0, alpha: 1.0)
    ]

    var board: [[SKSpriteNode?]] = [[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7),[SKSpriteNode?](repeating: nil, count: 7)]
    
    var paddedBoard: [[UIColor]] = [[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9),[UIColor](repeating: UIColor.white, count: 9), [UIColor](repeating: UIColor.white, count: 9)]
    
    var pv1Form = 0
    var pv1Color = UIColor(red:255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    var pv2Form = 0
    var pv2Color = UIColor(red:255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    
    var forms = [
        [
            // - o -
            // - o -
            // - o -
            [0,0,0],
            [1,1,1],
            [0,0,0]
        ],
        [
            // o - -
            // o - -
            // o o o
            [1,1,1],
            [1,0,0],
            [1,0,0]
        ],
        [
            // - o -
            // - o -
            // o o o
            [1,0,0],
            [1,1,1],
            [1,0,0]
        ],
        [
            // o o o
            // - o -
            // - o -
            [0,0,1],
            [1,1,1],
            [0,0,1]
        ],
        [
            // - - -
            // o o o
            // - - -
            [0,1,0],
            [0,1,0],
            [0,1,0]
        ],
        [
            // - o o
            // - o -
            // o o -
            [1,0,0],
            [1,1,1],
            [0,0,1]
        ],
        [
            // - - -
            // - o o
            // - o o
            [0,0,0],
            [1,1,0],
            [1,1,0]
        ],
        [
            // o o -
            // - o -
            // - o -
            [0,0,1],
            [1,1,1],
            [0,0,0]
        ]
    ]
    
    
    
    // entry point
    override func didMove(to view: SKView) {
        //self.removeAllChildren()
        sceneSize = self.size
        width = sceneSize.width
        borderWidth = 1.0
        squareNum = 7
        squareSize = CGSize(width: width/CGFloat(squareNum), height: width/CGFloat(squareNum))
        
        
        self.scaleMode = .resizeFill
        self.backgroundColor = UIColor(red:255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0) //white
        
        // Draw the board & previews
        fillBoard(width, borderWidth: borderWidth, squareSize: squareSize)
        drawBoard()
        drawRect()
        
        createPreview1()
        createPreview2()
        createScoreField()
        
        let bgurl = Bundle.main.url(forResource: "backgroundMusic.mp3", withExtension:nil)!
        self.playerBG = try! AVAudioPlayer(contentsOf: bgurl)
        self.playerBG.numberOfLoops = -1
        self.playerBG.play()
        
        let sspurl = Bundle.main.url(forResource: "singleSquarePop.wav", withExtension:nil)!
        self.playerSingleSquarePop = try! AVAudioPlayer(contentsOf: sspurl)
        self.playerSingleSquarePop.prepareToPlay()
        
        let fpurl = Bundle.main.url(forResource: "formPop.wav", withExtension:nil)!
        self.playerFormPop = try! AVAudioPlayer(contentsOf: fpurl)
        self.playerFormPop.prepareToPlay()
        
        let gourl = Bundle.main.url(forResource: "gameOverSound.wav", withExtension:nil)!
        self.playerGameOver = try! AVAudioPlayer(contentsOf: gourl)
        self.playerGameOver.prepareToPlay()
    }
    
    
    
    // GENERAL FUNCTIONS
    
    // getRandColor generates a random UIColor from colors array
    func getRandColor() -> UIColor {
        let rand = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[rand]
    }
    
    // getRandNumber returns a random number (0-amount of forms)
    func getRandNumber() -> Int{
        let rand = Int(arc4random_uniform(UInt32(forms.count)))
        return rand
    }
    
    // clearBoard clears the whole view // NOT USED YET
    func clearBoard(){
        self.removeAllChildren()
    }
    
    // GAME OVER
    func switchToGameOverScreen() {
        self.playerBG.stop()
        self.playerGameOver.play()
        self.viewController.changeView()
        self.viewController = nil // avoid memory leak
    }
    
    
    // GAMEBUILD FUNCTIONS
    
    // fillBoard fills board datastructure with SKSpriteNodes from bottom left with index 0/0
    func fillBoard(_ width: CGFloat, borderWidth: CGFloat, squareSize: CGSize){
        for y in 0 ..< board.count {
            for x in 0 ..< board.count {
                board[x][y] = createNode()
            }
        }
    }
    
    // createNode creates an SKSpriteNode
    func createNode() -> SKSpriteNode{
        return SKSpriteNode(color: getRandColor(), size:CGSize (width: squareSize.width-borderWidth, height: squareSize.width-borderWidth))
    }
    
    // drawBoard draws squares to view
    func drawBoard(){
        // Board parameters
        let xOffset:CGFloat = squareSize.width/2.0
        let yOffset:CGFloat = squareSize.width/2.0
        
        for y in 0 ..< board.count {
            for x in 0 ..< board.count {
                let square = board[x][y]!
                square.position = CGPoint(x: CGFloat(x) * squareSize.width + xOffset,
                    y: CGFloat(y) * squareSize.width + yOffset)
                self.addChild(square)
            }
        }
    }
    
    // drawRect draws a white rectangle behind the preview to hide new generated node descending from top
    func drawRect(){
        let rect = SKShapeNode(rectOf: CGSize(width: sceneSize.width, height: (sceneSize.height-sceneSize.width)))
        
        rect.fillColor = SKColor.white
        rect.position = CGPoint(x: sceneSize.width/2.0, y: sceneSize.height-(sceneSize.height-sceneSize.width)/2.0)
        rect.zPosition = 1.0
        
        self.addChild(rect)
    }
    
    // createScoreField creates a form with grey border for score
    func createScoreField() {
        let scorefield = SKShapeNode(rectOf: CGSize(width: sceneSize.width/7.0*5.0, height: sceneSize.height/10.0))
        scorefield.fillColor = SKColor.white
        scorefield.strokeColor = UIColor(red:190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        scorefield.lineWidth = 2.5
        scorefield.position = CGPoint(x: sceneSize.width/2.0, y: sceneSize.height-(sceneSize.height/9.0))
        scorefield.zPosition = 1.1
        
        self.addChild(scorefield)
        createScoreText(scorefield)
    }
    
    // createScoreText creates score text
    func createScoreText (_ scorefield: SKShapeNode) {
        let scoreText = SKLabelNode(fontNamed: "AppleSDGothicNeo-UltraLight")
        scoreText.text = "\(self.score)"
        scoreText.fontSize = 40
        scoreText.position = CGPoint(x: scorefield.frame.midX, y: scorefield.frame.midY-15)
        scoreText.fontColor = UIColor.black
        scoreText.zPosition = 2
        
        
        self.addChild(scoreText)
        self.scoreLabel = scoreText
    }
    
    // createPreview1 creates a big random form with random color (big preview)
    func createPreview1(){
        repeat {
            pv1Form = getRandNumber()
            pv1Color = getRandColor()
        } while (pv1Form == pv2Form || pv1Color.description == pv2Color.description)
        
        
        let waitDuration = SKAction.wait(forDuration: 0.6)
        let sequence = SKAction.sequence([waitDuration, SKAction.run({ () -> Void in
            self.createpb()
            self.testforPattern()
        })])
        
        // 3.5 size
        // 2.0 ox
        // 11.8 oy
        drawPreview(3.5, ox: 2.0, oy: 11.8, form: pv1Form, prevColor: pv1Color)
        
        self.run(sequence)
    }
    
    // createPreview2 creates a smaller random form with random color (small preview)
    func createPreview2(){
        repeat {
            pv2Form = getRandNumber()
            pv2Color = getRandColor()
        } while (pv2Form == pv1Form || pv2Color.description == pv1Color.description)
        
        let waitDuration = SKAction.wait(forDuration: 0.6)
        let sequence = SKAction.sequence([waitDuration, SKAction.run({ () -> Void in
            self.createpb()
            self.testforPattern()
        })])
        
        // 3.5 size
        // 6.5 ox
        // 11.8 oy
        drawPreview(3.5, ox: 6.5, oy: 11.8, form: pv2Form, prevColor: pv2Color)
        
        self.run(sequence)
    }
    
    // drawPreview adds the created previews to view
    func drawPreview(_ w:CGFloat, ox:CGFloat, oy:CGFloat, form:Int, prevColor:UIColor){
        sceneSize = self.size
        width = sceneSize.width/w
        borderWidth = 1.0
        squareNum = 3
        let previewSquareSize = CGSize(width: width/CGFloat(squareNum), height: width/CGFloat(squareNum))
        let xOffset:CGFloat = previewSquareSize.width*ox
        let yOffset:CGFloat = previewSquareSize.width*oy
        
        let form = forms[form]
        let white = UIColor.white
        var color = white
        
        for y in 0...squareNum-1 {
            for x in 0...squareNum-1 {
                if(form[x][y] == 1) {
                    color = prevColor
                }
                else {
                    color = white
                }
                
                let square = SKSpriteNode(color: color, size:CGSize (width: previewSquareSize.width-borderWidth, height: previewSquareSize.width-borderWidth))
                square.position = CGPoint(x: CGFloat(x) * previewSquareSize.width + xOffset,
                    y: CGFloat(y) * previewSquareSize.width + yOffset)
                square.zPosition = 1.5
                self.addChild(square)
            }
        }
    }
    
    
    
    // GAMELOOP FUNCTIONS
    
    // touchesBegan calculates index through touch position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let position :CGPoint = touch.location(in: view)
            if(position.y > 295){
                let scenePos = self.convertPoint(fromView: position)
                for y in 0 ..< board.count {
                    for x in 0 ..< board.count {
                        if(board[x][y]!.contains(scenePos)) {
                            userWantsToRemoveSquareAt(x, y: y)
                            if (self.score > 1) {
                                self.score = self.score - 1
                                self.scoreLabel.text = "\(self.score)"
                            }
                            else {
                               switchToGameOverScreen()
                            }
                            createpb()
                            testforPattern()
                            return
                        }
                    }
                }
            }
        }
    }
    
    // userWantsToRemoveSquareAt
    func userWantsToRemoveSquareAt(_ x: Int, y: Int){
        let touchedSquare:SKSpriteNode = board[x][y]!
        
        
        let resizeSquare = SKAction.resize(toWidth: 0.0, height: 0.0, duration: 0.3)
        let waitTime = SKAction.wait(forDuration: 0.05)
        let rotateSquare = SKAction.rotate(byAngle: 30.0, duration: 0.25)
        
        let seq = SKAction.sequence([waitTime, rotateSquare])
        
        let anim = SKAction.group([resizeSquare, seq])
        anim.timingMode = SKActionTimingMode.easeOut
        
        let sequence = SKAction.sequence([anim, SKAction.run({ () -> Void in
            touchedSquare.removeFromParent()
        })])
        
        touchedSquare.run(sequence)
        
        
        // updates datastructure
        for i in 0 ..< board.count - 1 - y {
            board[x][y+i] = board[x][y+i+1]
        }
        
        generateNewNode(x);
        
        for i in 0 ..< board.count - y {//all nodes above
            moveNode(x, y: board.count - i - 1)
        }
        
        self.playerSingleSquarePop.play()
    }
    
    // generateNewNode generates a new node in column x
    func generateNewNode(_ x: Int){
        let xOffset:CGFloat = squareSize.width/2.0
        let topRow = board.count-1
        
        let onTopNode = board[x][topRow]!.position.y + squareSize.width
        
        board[x][topRow] = createNode()
        
        let square = board[x][topRow]
        square!.position = CGPoint(x: CGFloat(x) * squareSize.width + xOffset,
            y: onTopNode)
        self.addChild(square!)
    }
    
    // moveNode moves Sqare to square position below with animation // SQUARES ZUSAMMENZIEHEN MIT DURATION SKACTION SEQUENCE
    func moveNode(_ x:Int,y: Int){
        let xOffset:CGFloat = squareSize.width/2.0
        
        let destY = CGFloat(y) * squareSize.width + xOffset
        let destX = CGFloat(x) * squareSize.width + xOffset
        let moveDown = SKAction.move(to: CGPoint(x: destX, y: destY), duration: 0.5)
        
        board[x][y]!.run(moveDown)
    }
    
    // createpb creates a padded board for matching algorithm
    func createpb(){
        
        for y in 0 ..< paddedBoard.count {
            for x in 0 ..< paddedBoard.count {
                if(x > 0 && y > 0 && x <= board.count && y <= board.count){
                    paddedBoard[x][y] = board[x-1][y-1]!.color
                }
                else {
                    paddedBoard[x][y] = UIColor.white
                }
            }
        }
    }
    
    //
    // algorithm for pattern matching
    func testforPattern() {
        var matrix: [[UIColor]] = [[UIColor](repeating: UIColor.white as UIColor, count: 3),[UIColor](repeating: UIColor.white as UIColor, count: 3),[UIColor](repeating: UIColor.white as UIColor, count: 3)]
        
        for y in 0 ..< paddedBoard.count-2 {
            for x in 0 ..< paddedBoard.count-2 {
                
                matrix[0][0] = paddedBoard[x][y]
                matrix[1][0] = paddedBoard[x+1][y]
                matrix[2][0] = paddedBoard[x+2][y]
                
                matrix[0][1] = paddedBoard[x][y+1]
                matrix[1][1] = paddedBoard[x+1][y+1]
                matrix[2][1] = paddedBoard[x+2][y+1]
                
                matrix[0][2] = paddedBoard[x][y+2]
                matrix[1][2] = paddedBoard[x+1][y+2]
                matrix[2][2] = paddedBoard[x+2][y+2]
                
                let preview1 = generatePrevMatrix(pv1Form, color:pv1Color)
                let preview2 = generatePrevMatrix(pv2Form, color:pv2Color)
                
                // deleteFoundForm params: -1 per value to get board index
                if (comparePattern(matrix, prev:preview1)) {
                    deleteFoundForm(x-1, y: y-1, form:pv1Form)
                    self.score = self.score + 5
                    self.scoreLabel.text = "\(self.score)"
                    createPreview1()
                }
                
                if(comparePattern(matrix, prev:preview2)) {
                    deleteFoundForm(x-1, y: y-1, form:pv2Form)
                    self.score = self.score + 5
                    self.scoreLabel.text = "\(self.score)"
                    createPreview2()
                }
                
            }
        }
    }
    
    // generatePrevMatrix converts form matrix to color matrix with previewcolor
    func generatePrevMatrix(_ index:Int, color:UIColor)-> [[UIColor]] {
        var prev: [[UIColor]] = [[UIColor](repeating: UIColor.white as UIColor, count: 3),[UIColor](repeating: UIColor.white as UIColor, count: 3),[UIColor](repeating: UIColor.white as UIColor, count: 3)]
        
        var form = forms[index]
        
        for y in 0 ..< prev.count {
            for x in 0 ..< prev.count {
                if (form[x][y] == 1) {
                    prev[x][y] = color
                }
                else {
                    prev[x][y] = UIColor.white
                }
            }
        }
        return prev
    }
    
    // comparePattern compares preview form with matrix via colors
    func comparePattern(_ matrix: [[UIColor]], prev: [[UIColor]])-> Bool  {
        let white = UIColor.white
        
        for y in 0 ..< matrix.count {
            for x in 0 ..< matrix.count {   // Loop over columns
                if (prev[x][y] != white) {
                    if (prev[x][y].description != matrix[x][y].description) {
                        return false
                    }
                }
            }
        }
        return true // return true if every part of the pattern is matching
    }
    
    // deleteFoundForm iterates over form matrix to delete matching squares from foundform in board
    func deleteFoundForm(_ x: Int, y: Int, form: Int) {
        self.playerFormPop.play()
        var f = forms[form]
        var removeX = 0
        var removeY = 0
        
        //for var fy = f.count-1; fy >= 0; fy -= 1 { //OLD SYNTAX --> changed to new xCode8 Syntax
        for var fy in (f.count-1..<f.count-1).reversed() {
            //for var fx = f.count-1; fx >= 0; fx -= 1 {   // Loop over columns    //OLD SYNTAX --> changed to new xCode8 Syntax
            for var fx in (f.count-1..<f.count-1).reversed() {
                if (f[fx][fy] == 1) {
                    removeX = x+fx
                    removeY = y+fy
                    userWantsToRemoveSquareAt(removeX, y: removeY)
                }
            }
        }
    }

    

    // PRINT FUNCTIONS
    
    func printArrays(_ m: [[UIColor]]) {
        for y in 0 ..< m.count {
            for x in 0 ..< m.count {
                print("x: ", x, " y: ", y, " (", m[x][y], ")")
            }
        }
    }
    
    func printIntArrays(_ m: [[Int]]) {
        print("new Form")
        for y in 0 ..< m.count {
            for x in 0 ..< m.count {
                print("x: ", x, " y: ", y, " (", m[x][y], ")")
            }
        }
    }
    
    func printSpriteNode(_ m: [[SKSpriteNode?]]) {
        for y in 0 ..< m.count {
            for x in 0 ..< m.count {
                print("x: ", x, " y: ", y, " (", m[x][y]!.color, ")")
            }
        }
    }
}

//
//  GameViewController.swift
//  Breakout
//
//  Created by Patrick Pan on 7/19/15.
//  Copyright (c) 2015 Patrick Pan. All rights reserved.
//

import UIKit
import QuartzCore


class GameViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var livesLabel: UILabel!
    var livesRemaining = 4
    
    var numberOfBricks = 100
    var ballSpeed:CGFloat = 0.033
    
    @IBOutlet weak var scoreLabel: UILabel!
    var currentScore = 0
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    var needToResetGame = false
    
    var brickStorage = [String:UIView]()
    
    var ballView: UIView? = nil
    var paddleView: UIView? = nil
    
    var paddleX: CGFloat? = nil
    var paddleSizeMultiplier:CGFloat = 1
    var paddleSize:CGSize {
        get{
            return CGSize(width: values.paddleSize.width * paddleSizeMultiplier, height: values.paddleSize.height)
        }
    }
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedUIDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        return lazilyCreatedUIDynamicAnimator
    }()
    
    //actually initialized to
    lazy var pushBehavior: UIPushBehavior = {
        let lazilyCreatedPush = UIPushBehavior()
        lazilyCreatedPush.setAngle(180, magnitude: 0.008)
        return lazilyCreatedPush
    }()
    
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        lazilyCreatedCollider.collisionDelegate = self
        return lazilyCreatedCollider
    }()
    

    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying) {
        
        let id:String = "\([identifier])"
        var secondChar = advance(id.startIndex, 1)
        //println("Collision with id = \(id)")
        if id[secondChar] == "(" {
            if let brick = brickStorage[id]{
//                let time: NSTimeInterval = 0.0
//                let delay: NSTimeInterval = 1.0
//                UIView.animateWithDuration(time, delay: delay, options: UIViewAnimationCurve.EaseInOut, animations: {brick.alpha = 0.0}, completion: nil)

                collider.removeBoundaryWithIdentifier(identifier)
                brick.removeFromSuperview()
                
                currentScore += 1
                updateScoreLife()
                
                if brick.backgroundColor == UIColor.blueColor() {
                    println("Hit blue brik!")
                    if paddleView != nil {
                        paddleView?.removeFromSuperview()
                    }
                    paddleSizeMultiplier = paddleSizeMultiplier + 0.2
                    createPaddle(paddleSize)
                    
                }
            }
        }
        
        if id == "[ow]" {
            if let ball = item as? UIView{
                collider.removeItem(ball)
                ballBahavior.removeItem(ball)
                pushBehavior.removeItem(ball)
                ball.removeFromSuperview()
                paddleSizeMultiplier = 1
                createBall()
                createPaddle()
                
                livesRemaining -= 1
                updateScoreLife()
                
                //add behavior to animator
                animator.addBehavior(pushBehavior)
                animator.addBehavior(collider)
                animator.addBehavior(ballBahavior)
            }
        }
        
    }
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed:
            let translation = sender.translationInView(gameView)
            paddleX! += CGFloat(translation.x/5)
            if paddleX! < 0 {
                paddleX! = 0
            }
            if paddleX! + paddleSize.width > containerView.frame.maxX{
                paddleX! = containerView.frame.maxX - paddleSize.width
            }
            createPaddle()
        default :
            break
        }
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            pushBehavior.active = true
        }
    }
    
    func updateScoreLife(){
        livesLabel.text = "\(livesRemaining)"
        scoreLabel.text = "\(currentScore)"
    }
    lazy var ballBahavior: UIDynamicItemBehavior = {
        let ballBehavior = UIDynamicItemBehavior()
        ballBehavior.allowsRotation = true
        ballBehavior.elasticity = 1.01
        ballBehavior.resistance = 0
        ballBehavior.friction = 0
        ballBehavior.angularResistance = 0
        
        return ballBehavior
    }()
    
    struct values {
        //static var numberOfBricks = 50
        static var leftMargin: CGFloat = 20
        static var topMargin:CGFloat = 20
        static var rightMargin:CGFloat = 20
        static var brickSize = CGSize(width: 30, height: 20)
        static var ballSize = CGSize(width: 10, height: 10)
        static var paddleSize = CGSize(width: 100, height: 2)
    }
    
    var numberOfBricksPerRow: CGFloat {
        get {
            let frameWidth = containerView.frame.width-values.leftMargin-values.rightMargin
            return frameWidth/values.brickSize.width
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if needToResetGame == true {
            resetGame()
            needToResetGame == false
        }
        println("View Appeared! ball speed = \(ballSpeed)")
    }
    
    func resetGame(){
        currentScore = 0
        updateScoreLife()
        
        animator.removeAllBehaviors()
        //animator.removeBehavior(ballBahavior)
        collider.removeAllBoundaries()
        
        paddleX = containerView.frame.width/2
        
        createWall()
        createBricks()
        createBall()
        createPaddle()

        //add behavior to animator
        animator.addBehavior(collider)
        animator.addBehavior(ballBahavior)
        
    }
    func createWall(){
        
        var rightframe = CGRect(origin: CGPoint(x: containerView.frame.width-5, y: 0), size: CGSize(width: 2, height: containerView.frame.height))
        var topframe = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: containerView.frame.width, height: 2))
        var leftframe = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 2, height: containerView.frame.height))
        var outframe = CGRect(origin: CGPoint(x: 0, y: containerView.frame.height-10), size: CGSize(width: containerView.frame.width, height: 1))
        
        
        let rightWallPath = UIBezierPath(rect: rightframe)
        let leftWallPath = UIBezierPath(rect: leftframe)
        let topWallPath = UIBezierPath(rect: topframe)
        let outWallPath = UIBezierPath(rect: outframe)
        
        
        collider.addBoundaryWithIdentifier("lw", forPath: rightWallPath)
        collider.addBoundaryWithIdentifier("tw", forPath: topWallPath)
        collider.addBoundaryWithIdentifier("rw", forPath: leftWallPath)
        collider.addBoundaryWithIdentifier("ow", forPath: outWallPath)
    }
    func createBall(){
        var frame = CGRect(origin: CGPoint(x: paddleX!, y: containerView.frame.height/2), size: values.ballSize)
        if ballView != nil {
            ballView?.removeFromSuperview()
            collider.removeItem(ballView!)
            ballBahavior.removeItem(ballView!)
        }
        
        ballView = UIView(frame: frame)
        ballView!.backgroundColor = UIColor.blackColor()
       
        ballView!.layer.cornerRadius = 5
        
        
        pushBehavior = UIPushBehavior(items: [ballView!], mode: UIPushBehaviorMode.Instantaneous)
        let angle = CGFloat(arc4random()%360)
        println("angle = \(angle)")
        pushBehavior.setAngle(angle, magnitude: ballSpeed)
        pushBehavior.active = false
        
        gameView.addSubview(ballView!)
        pushBehavior.addItem(ballView!)
        collider.addItem(ballView!)
        ballBahavior.addItem(ballView!)
        
        animator.addBehavior(pushBehavior)
        //animator.addBehavior(ballBahavior)
    }
    
    func createPaddle(paddleSize: CGSize){
        var frame = CGRect(origin: CGPoint(x: paddleX!, y: containerView.frame.height - containerView.frame.height/4), size: paddleSize)
        if paddleView != nil {
            paddleView?.removeFromSuperview()
        }
        paddleView = UIView(frame: frame)
        paddleView!.backgroundColor = UIColor.blueColor()
        
        let paddlePath = UIBezierPath(rect: frame)
        collider.removeBoundaryWithIdentifier("")
        
        collider.addBoundaryWithIdentifier("", forPath: paddlePath)
        gameView.addSubview(paddleView!)
    }
    
    func createPaddle() {
        createPaddle(paddleSize)
    }
    
    func createBricks() {
        var currentRow:CGFloat = 0
        var bricksInCurrentRow: CGFloat = 0
        
        //remove bricks from view first
        for (_, brick) in brickStorage {
            brick.removeFromSuperview()
        }
        
        
        for var x = 0; x < numberOfBricks; ++x{
            var frame = CGRect(origin: CGPointZero, size: values.brickSize)
            //start new row
            if (bricksInCurrentRow+1 >= numberOfBricksPerRow){
                currentRow+=1
                frame.origin.x = values.leftMargin
                frame.origin.y = values.topMargin + values.brickSize.height*currentRow
                bricksInCurrentRow = 1
            //still in same row
            } else {
                frame.origin.x = values.leftMargin + bricksInCurrentRow*values.brickSize.width
                frame.origin.y = values.topMargin + values.brickSize.height*currentRow
                bricksInCurrentRow+=1
            }
            let brickView = UIView(frame: frame)
            brickView.backgroundColor = UIColor.random
            
            gameView.addSubview(brickView)
            let boundryKey = "\(frame.origin)"
            let brickKey = "[\(frame.origin)]"
            //println("broundry key = \(boundryKey)")
            brickStorage[brickKey] = brickView
            let brickPath = UIBezierPath(rect: frame)
            collider.addBoundaryWithIdentifier(boundryKey, forPath: brickPath)
            
        }
    }

}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%10 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        case 5: return UIColor.brownColor()
        case 6: return UIColor.yellowColor()
        case 7: return UIColor.magentaColor()
        case 8: return UIColor.darkGrayColor()
        case 9: return UIColor.cyanColor()
        default: return UIColor.lightGrayColor()
        }
    }
}


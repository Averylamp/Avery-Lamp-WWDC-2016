//
//  HomeViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 2/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


//background color fading
enum BackgroundDirection {
    case Up
    case Down
    case Stop
}
enum BackgroundNum{
    case First
    case Second
}

class HomeViewController: UIViewController {
    
    var animationFlag: BackgroundDirection = .Up
    var bgNumFlag: BackgroundNum = .First
    var lastState:BackgroundDirection?
    
    var bgScroll:UIImageView?
    var bgScroll2:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        //Two backgrounds
        bgScroll = UIImageView(frame: CGRectMake(0, 0, width, height * 3))
        bgScroll?.alpha = 0
        bgScroll?.contentMode = UIViewContentMode.ScaleAspectFill
        bgScroll?.image = UIImage(named: "bg")
        self.view.addSubview(bgScroll!)
        
        bgScroll2 = UIImageView(frame: CGRectMake(0, 0, width, height * 3))
        bgScroll2?.alpha = 0
        bgScroll2?.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bgScroll2!)
        
        //Initial fade in
        UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bgScroll?.alpha = 1.0
        }, completion: nil)
        delay(5.0) { () -> () in
            self.startAnimation()
        }
        
        let circleDrawDelay = 1.0
        let circleDrawDuration = 1.0
        let labelDrawDelay = Double(1.0)
        let labelDrawDuration = Double(2.0)
        //My Story
        let topIconsHeightOffset = height / 3 + 60 + 20
        let detailFontSize = CGFloat(25)
        createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width / 2 , height / 3) , size:120, left: true)
        let storyLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        storyLabel.center = CGPointMake(width / 2 , topIconsHeightOffset)
        storyLabel.text = "My Story"
        storyLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        storyLabel.textAlignment = NSTextAlignment.Center
        storyLabel.strokeTextSimultaneously(width: 0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(storyLabel)
        
        let myStoryButton = UIButton(frame: CGRectMake(0,0,120,120))
        myStoryButton.center = CGPointMake(width / 2, height / 3)
        myStoryButton.layer.cornerRadius = 60
        myStoryButton.addTarget(self, action: #selector(HomeViewController.goToMyStory), forControlEvents: UIControlEvents.TouchUpInside)
        myStoryButton.layer.masksToBounds = true
        myStoryButton.clipsToBounds = true
        self.view.addSubview(myStoryButton)

        
        let bottomIconsHeightOffset = height * 2 / 3 + 60 + 20
        
        //My Info
        createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width / 4 , height * 2 / 3) , size:120, left: true)
        let infoLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        infoLabel.center = CGPointMake(width / 4 , bottomIconsHeightOffset)
        infoLabel.text = "My Info"
        infoLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.strokeTextSimultaneously(width: 0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(infoLabel)
        
        let myInfoButton = UIButton(frame: CGRectMake(0,0,120,120))
        myInfoButton.center = CGPointMake(width / 4, height * 2 / 3)
        myInfoButton.layer.cornerRadius = 60
        myInfoButton.addTarget(self, action: #selector(HomeViewController.goToMyInfo), forControlEvents: UIControlEvents.TouchUpInside)
        myInfoButton.layer.masksToBounds = true
        myInfoButton.clipsToBounds = true
        self.view.addSubview(myInfoButton)
        
        // My Apps
        createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width * 3 / 4 , height * 2 / 3) , size:120, left: false)
        let appsLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        appsLabel.center = CGPointMake(width * 3 / 4 , bottomIconsHeightOffset)
        appsLabel.text = "My Apps"
        appsLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        appsLabel.textAlignment = NSTextAlignment.Center
        appsLabel.strokeTextSimultaneously(width: 0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(appsLabel)
        
        let myAppsButton = UIButton(frame: CGRectMake(0,0,120,120))
        myAppsButton.center = CGPointMake(width * 3 / 4, height * 2 / 3)
        myAppsButton.layer.cornerRadius = 60
        myAppsButton.addTarget(self, action: #selector(HomeViewController.goToMyApps), forControlEvents: UIControlEvents.TouchUpInside)
        myAppsButton.layer.masksToBounds = true
        myAppsButton.clipsToBounds = true
        self.view.addSubview(myAppsButton)
        
        //Welcome
        let label = UILabel(frame: CGRectMake(0,0,width, 100))
        label.text = "Welcome"
        label.font = UIFont(name: "Panton-Regular", size: 40)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        label.strokeTextAnimated(width: 1.0, duration: 2, fade: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if animationFlag == .Stop && lastState != nil{
            animationFlag = lastState!
            startAnimation()
        }
    }
    
    //Drawing the circle from the side
    func createLineCircle(delayt: Double, duration: Double, fadeDelay:Double, location: CGPoint, size: CGFloat, left: Bool){
        let line = CAShapeLayer()
        line.position = CGPointMake(0, 0)
        line.lineWidth = 0
        line.strokeColor = UIColor.blackColor().CGColor
        line.fillColor = UIColor.clearColor().CGColor
        
        let path = CGPathCreateMutable()
        
        var points = Array<CGPoint>()
        if left {
            points = Array(arrayLiteral: CGPointMake(0,location.y - size / 2),CGPointMake(location.x,location.y - size / 2))
        }else{
            points = Array(arrayLiteral: CGPointMake(self.view.frame.width,location.y - size / 2),CGPointMake(location.x,location.y - size / 2))
        }
        CGPathAddLines(path, nil, points, 2)
        var circlePath: CGPath?
        if left {
            circlePath = UIBezierPath(roundedRect: CGRectMake(location.x - size / 2,location.y - size / 2, size, size), cornerRadius: size).CGPath
        }else {
            circlePath = UIBezierPath(roundedRect: CGRectMake(location.x - size / 2,location.y - size / 2, size, size), cornerRadius: size).bezierPathByReversingPath().CGPath
        }
        CGPathAddPath(path, nil, circlePath)
        line.path  = path
        
        let circle = CAShapeLayer()
        circle.path = circlePath
        circle.position = CGPointMake(0, 0)
        circle.lineWidth = 0
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor.blackColor().CGColor
        self.view.layer.addSublayer(circle)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = NSNumber(float: 0.0)
        drawAnimation.toValue = NSNumber(float: 1.0)
        drawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let undrawAnimation = CABasicAnimation(keyPath: "strokeStart")
        undrawAnimation.duration = duration * 2
        undrawAnimation.repeatCount = 1
        undrawAnimation.fromValue = NSNumber(float: 0.0)
        undrawAnimation.toValue = NSNumber(float: 1.0)
        undrawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.view.layer.addSublayer(line)
        
        delay(delayt) { () -> () in
            line.lineWidth = 2
            line.addAnimation(drawAnimation, forKey: "drawLineAnimation")
            self.delay(fadeDelay, closure: { () -> () in
                line.addAnimation(undrawAnimation, forKey: "undrawLineAnimation")
                circle.lineWidth = 2
                self.delay(undrawAnimation.duration * 3 / 4, closure: { () -> () in
                    line.lineWidth = 0
                    line.removeFromSuperlayer()
                })
            })
        }
    }
    
    //Animation for background color flow
    func startAnimation () {
        UIView.animateWithDuration(5.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            if self.animationFlag == .Down {
                self.bgScroll!.frame.origin.y = -self.bgScroll!.frame.height + UIScreen.mainScreen().bounds.height
                self.bgScroll2!.frame.origin.y = -self.bgScroll2!.frame.height + UIScreen.mainScreen().bounds.height
                self.animationFlag = .Up
            } else if self.animationFlag == .Up {
                self.bgScroll!.frame.origin.y = 0
                self.bgScroll2!.frame.origin.y = 0
                self.animationFlag = .Down
            }
            self.lastState = self.animationFlag
            }, completion: { (finished: Bool) in
                if self.animationFlag != .Stop{
                    UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            if self.animationFlag == .Up{
                                if self.bgNumFlag == .First{
                                    self.bgScroll!.alpha = 0.0
                                    self.bgScroll2!.image = self.randomizedBGColor()
                                    self.bgScroll2!.alpha = 1.0
                                    self.bgNumFlag = .Second
                                }else{
                                    self.bgScroll!.image = self.randomizedBGColor()
                                    self.bgScroll!.alpha = 1.0
                                    self.bgScroll2!.alpha = 0.0
                                    self.bgNumFlag = .First
                                }
                            }
                        
                        }, completion: { [weak self] finished in
                            self?.startAnimation()
                    })
                }
            })
    }
    
    //Background colors to pick from
    let bgColors = [UIColor(hex6: 0xfdb86b),UIColor(hex6: 0xe6a14b),UIColor(hex6: 0xfc5e6f),UIColor(hex6: 0xf3b93e),UIColor(hex6: 0x62cbfa),UIColor(hex6: 0xd08ab4),UIColor(hex6: 0xb8fbb4),UIColor(hex6: 0x2ffbfc)]
    
    //Random Color Set Picker
    func randomizedColorSet() -> Array<CGColor>{
        var arr = Array<CGColor>()
        let rand = arc4random() >> 1
        let randNum = Int(rand) % bgColors.count
        let firstColor = bgColors[randNum]
        arr.append(firstColor.CGColor)
        var rand2 = arc4random() >> 1
        var randNum2 = Int(rand2) % bgColors.count
        while randNum2 == randNum {
            rand2 = arc4random() >> 1
            randNum2 = Int(rand2) % bgColors.count
        }
        let secondColor = bgColors[randNum2]
        arr.append(secondColor.CGColor)
        return arr
    }
    //Single gradient from random colors
    func randomizedBGColor()->UIImage{
        let gradient = CAGradientLayer()
        gradient.backgroundColor = UIColor.greenColor().CGColor
        gradient.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 2)
        gradient.colors = randomizedColorSet()
        let image = imageFromLayer(gradient)
        return image
    }
    
    //Gradient layer to image
    func imageFromLayer(layer:CALayer) -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
    // MARK: - Navigation
    func goToMyStory(){
        self.animationFlag = .Stop
        self.navigationController?.pushViewController(MyStoryViewController(), animated: true)
    }
    
    func goToMyInfo(){
        self.animationFlag = .Stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAppsTVC = storyboard.instantiateViewControllerWithIdentifier("MyInfoVC")
        self.navigationController?.pushViewController(myAppsTVC, animated: true)
        
    }
    
    func goToMyApps(){
        self.animationFlag = .Stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAppsTVC = storyboard.instantiateViewControllerWithIdentifier("MyAppsTVC")
        self.navigationController?.pushViewController(myAppsTVC, animated: true)
        
    }
    
}

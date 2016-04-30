//
//  HomeViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/3/16.
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
        myStoryCircle =  createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width / 2 , height / 3) , size:120, left: true)
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
        myInfoCircle = createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width / 4 , height * 2 / 3) , size:120, left: true)
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
        myAppsCircle =  createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPointMake(width * 3 / 4 , height * 2 / 3) , size:120, left: false)
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
        
        print("Bounds Circle \(CGPathGetBoundingBox(myAppsCircle?.path))")
        drawIcons()
    }
    
    func drawIcons() {
        //Info Icon
        let infoIconpath = UIBezierPath(roundedRect: CGRectMake(0, 0, 60, 75), cornerRadius: 3)
        infoIconpath.moveToPoint(CGPointMake(10,10))
        infoIconpath.addLineToPoint(CGPointMake(20, 10))
        infoIconpath.moveToPoint(CGPointMake(17.5,17))
        infoIconpath.addLineToPoint(CGPointMake(50, 17))
        infoIconpath.moveToPoint(CGPointMake(10,24))
        infoIconpath.addLineToPoint(CGPointMake(50, 24))
        infoIconpath.moveToPoint(CGPointMake(10,31))
        infoIconpath.addLineToPoint(CGPointMake(50, 31))
        infoIconpath.moveToPoint(CGPointMake(10,38))
        infoIconpath.addLineToPoint(CGPointMake(50, 38))
        infoIconpath.moveToPoint(CGPointMake(10,45))
        infoIconpath.addLineToPoint(CGPointMake(50, 45))
        infoIconpath.moveToPoint(CGPointMake(10,52))
        infoIconpath.addLineToPoint(CGPointMake(50, 52))
        infoIconpath.moveToPoint(CGPointMake(40,66))
        infoIconpath.addLineToPoint(CGPointMake(50, 66))
        
        let infoShape = CAShapeLayer()
        infoShape.path = infoIconpath.CGPath
        infoShape.strokeColor = UIColor.blackColor().CGColor
        infoShape.lineWidth = 1.0
        infoShape.fillColor = nil
        var pointOffset = CGPathGetBoundingBox(myInfoCircle!.path).origin
        infoShape.position = CGPointMake(pointOffset.x + 30, pointOffset.y + 23)
        myInfoCircle?.addSublayer(infoShape)
        
        //My Apps Icon
        let appsIconPath = UIBezierPath(roundedRect: CGRectMake(0, 0, 75, 75), cornerRadius: 17)
        appsIconPath.moveToPoint(CGPointMake(20.5, 12.0))
        appsIconPath.addArcWithCenter(CGPointMake(20.5, 24.5), radius: 12.5, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
        appsIconPath.moveToPoint(CGPointMake(57, 7))
        appsIconPath.addLineToPoint(CGPointMake(72, 32))
        appsIconPath.addLineToPoint(CGPointMake(42, 32))
        appsIconPath.addLineToPoint(CGPointMake(57, 7))
        appsIconPath.moveToPoint(CGPointMake(20.5, 42))
        appsIconPath.addLineToPoint(CGPointMake(32.5, 50.6))
        appsIconPath.addLineToPoint(CGPointMake(27.9, 64.6))
        appsIconPath.addLineToPoint(CGPointMake(13.1, 64.61))
        appsIconPath.addLineToPoint(CGPointMake(8.61, 50.6))
        appsIconPath.addLineToPoint(CGPointMake(20.5, 42))
        appsIconPath.moveToPoint(CGPointMake(27, 27))
        appsIconPath.addLineToPoint(CGPointMake(57, 27))
        appsIconPath.addLineToPoint(CGPointMake(57, 57))
        appsIconPath.addLineToPoint(CGPointMake(27, 57))
        appsIconPath.addLineToPoint(CGPointMake(27, 27))
        
        let appsShape = CAShapeLayer()
        appsShape.path = appsIconPath.CGPath
        appsShape.strokeColor = UIColor.blackColor().CGColor
        appsShape.lineWidth = 1.0
        appsShape.fillColor = nil
        pointOffset = CGPathGetBoundingBox(myAppsCircle!.path).origin
        appsShape.position = CGPointMake(pointOffset.x + 23, pointOffset.y + 23)
        myAppsCircle?.addSublayer(appsShape)
        
        //My Story Icon
        let storyPath = UIBezierPath()
        
        storyPath.moveToPoint(CGPointMake(20,64.9))
        let storyPathPoints = [CGPointMake(20,64.9), CGPointMake(43.36, 80.12), CGPointMake(64.83, 50.01), CGPointMake(82.3, 65.9), CGPointMake(102.2, 51.02)]
        
        let p2 = storyPathPoints[0]
        storyPath.moveToPoint(CGPointMake(p2.x, p2.y - 3))
        storyPath.addArcWithCenter(p2, radius: 3, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
        let pointArr = [CGPointMake(p2.x, p2.y - 5), CGPointMake(p2.x - 4, p2.y - 15), CGPointMake(p2.x, p2.y - 23), CGPointMake(p2.x + 4, p2.y - 15), CGPointMake(p2.x, p2.y - 5)]
        storyPath.moveToPoint(pointArr[0])
        for index in 1..<pointArr.count{
            let p1 = pointArr[index]
            storyPath.addLineToPoint(p1)
        }
        storyPath.moveToPoint(p2)
        
        for index in 1..<storyPathPoints.count{
            let p2 = storyPathPoints[index]
            let p1 = storyPathPoints[index - 1]
            let midpoint = midpointOfPoints(p1, secondPoint: p2)
            storyPath.addQuadCurveToPoint(midpoint, controlPoint: controlPointForPoints(midpoint, p2: p1))
            storyPath.addQuadCurveToPoint(p2, controlPoint: controlPointForPoints(midpoint, p2: p2))
            storyPath.moveToPoint(CGPointMake(p2.x, p2.y - 3))
            storyPath.addArcWithCenter(p2, radius: 3, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
            let pointArr = [CGPointMake(p2.x, p2.y - 5), CGPointMake(p2.x - 4, p2.y - 15), CGPointMake(p2.x, p2.y - 23), CGPointMake(p2.x + 4, p2.y - 15), CGPointMake(p2.x, p2.y - 5)]
            storyPath.moveToPoint(pointArr[0])
            for index in 1..<pointArr.count{
                let p1 = pointArr[index]
                storyPath.addLineToPoint(p1)
            }
            storyPath.moveToPoint(p2)
        }

        let storyShape = CAShapeLayer()
        storyShape.path = storyPath.CGPath
        storyShape.strokeColor = UIColor.blackColor().CGColor
        storyShape.lineWidth = 1.0
        storyShape.fillColor = nil
        pointOffset = CGPathGetBoundingBox(myStoryCircle!.path).origin
        storyShape.position = pointOffset
        myStoryCircle?.addSublayer(storyShape)
        
        
        infoShape.lineWidth = 0.0
        appsShape.lineWidth = 0.0
        storyShape.lineWidth = 0.0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = NSNumber(float: 0.0)
        strokeAnimation.toValue = NSNumber(float: 1.0)
        strokeAnimation.duration = 46.0
        delay(1.5) {
            infoShape.lineWidth = 1.0
            appsShape.lineWidth = 1.0
            storyShape.lineWidth = 1.0
            
            infoShape.addAnimation(strokeAnimation, forKey: "Stroke Animation")
            appsShape.addAnimation(strokeAnimation, forKey: "Stroke Animation")
            storyShape.addAnimation(strokeAnimation, forKey: "Stroke Animation")
        }
    }
    
    private func midpointOfPoints(firstPoint: CGPoint, secondPoint:CGPoint)->CGPoint{
        return CGPointMake((firstPoint.x + secondPoint.x) / 2, (firstPoint.y + secondPoint.y) / 2)
    }
    
    private func controlPointForPoints(p1: CGPoint, p2: CGPoint)-> CGPoint{
        var controlPoint = midpointOfPoints(p1, secondPoint: p2)
        let diffy = abs((p2.y - controlPoint.y))
        if p1.y < p2.y {
            controlPoint.y += diffy
        }else if p1.y > p2.y{
            controlPoint.y  -= diffy
        }
        return controlPoint
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if animationFlag == .Stop && lastState != nil{
            animationFlag = lastState!
            startAnimation()
        }
    }
    var myStoryCircle: CAShapeLayer?
    var myInfoCircle: CAShapeLayer?
    var myAppsCircle: CAShapeLayer?
    
    //Drawing the circle from the side
    func createLineCircle(delayt: Double, duration: Double, fadeDelay:Double, location: CGPoint, size: CGFloat, left: Bool)->CAShapeLayer{
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
        return circle
    }
    
    //Animation for background color flow
    func startAnimation () {
        UIView.animateWithDuration(4.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myStoryTVC = storyboard.instantiateViewControllerWithIdentifier("MyStoryVC")
        self.navigationController?.pushViewController(myStoryTVC, animated: true)
    }
    
    func goToMyInfo(){
        self.animationFlag = .Stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myInfoTVC = storyboard.instantiateViewControllerWithIdentifier("MyInfoVC")
        self.navigationController?.pushViewController(myInfoTVC, animated: true)
        
    }
    
    func goToMyApps(){
        self.animationFlag = .Stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAppsTVC = storyboard.instantiateViewControllerWithIdentifier("MyAppsTVC")
        self.navigationController?.pushViewController(myAppsTVC, animated: true)
        
    }
    
}

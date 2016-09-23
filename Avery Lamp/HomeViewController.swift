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
    case up
    case down
    case stop
}
enum BackgroundNum{
    case first
    case second
}

class HomeViewController: UIViewController {
    
    var animationFlag: BackgroundDirection = .up
    var bgNumFlag: BackgroundNum = .first
    var lastState:BackgroundDirection?
    
    var bgScroll:UIImageView?
    var bgScroll2:UIImageView?
    
    var myStoryButton: ForceTouchButton! = nil
    var myInfoButton: ForceTouchButton! = nil
    var myAppsButton: ForceTouchButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        //Two backgrounds
        bgScroll = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height * 3))
        bgScroll?.alpha = 0
        bgScroll?.contentMode = UIViewContentMode.scaleAspectFill
        bgScroll?.image = UIImage(named: "bg")
        bgScroll?.isUserInteractionEnabled = false
        self.view.addSubview(bgScroll!)
        
        bgScroll2 = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height * 3))
        bgScroll2?.alpha = 0
        bgScroll2?.contentMode = UIViewContentMode.scaleAspectFill
        bgScroll2?.isUserInteractionEnabled = false
        self.view.addSubview(bgScroll2!)
        
        //Initial fade in
        UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
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
        myStoryCircle =  createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPoint(x: width / 2 , y: height / 3) , size:120, left: true)
        let storyLabel = UILabel(frame: CGRect(x: 0,y: 0, width: width / 2, height: 30))
        storyLabel.center = CGPoint(x: width / 2 , y: topIconsHeightOffset)
        storyLabel.text = "My Story"
        storyLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        storyLabel.textAlignment = NSTextAlignment.center
        storyLabel.strokeTextSimultaneously(0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(storyLabel)
        
        myStoryButton = ForceTouchButton(frame: CGRect(x: 0,y: 0,width: 120,height: 120))
        myStoryButton.homeController = self
        myStoryButton.center = CGPoint(x: width / 2, y: height / 3)
        myStoryButton.layer.cornerRadius = 60
        myStoryButton.addTarget(self, action: #selector(HomeViewController.goToMyStory), for: UIControlEvents.touchUpInside)
        myStoryButton.layer.masksToBounds = true
        myStoryButton.clipsToBounds = true
        self.view.addSubview(myStoryButton)

        
        let bottomIconsHeightOffset = height * 2 / 3 + 60 + 20
        
        //My Info
        myInfoCircle = createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPoint(x: width / 4 , y: height * 2 / 3) , size:120, left: true)
        let infoLabel = UILabel(frame: CGRect(x: 0,y: 0, width: width / 2, height: 30))
        infoLabel.center = CGPoint(x: width / 4 , y: bottomIconsHeightOffset)
        infoLabel.text = "My Info"
        infoLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.strokeTextSimultaneously(0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(infoLabel)
        
        myInfoButton = ForceTouchButton(frame: CGRect(x: 0,y: 0,width: 120,height: 120))
        myInfoButton.homeController = self
        myInfoButton.center = CGPoint(x: width / 4, y: height * 2 / 3)
        myInfoButton.layer.cornerRadius = 60
        myInfoButton.addTarget(self, action: #selector(HomeViewController.goToMyInfo), for: UIControlEvents.touchUpInside)
        myInfoButton.layer.masksToBounds = true
        myInfoButton.clipsToBounds = true
        self.view.addSubview(myInfoButton)
        
        // My Apps
        myAppsCircle =  createLineCircle(0, duration: circleDrawDuration, fadeDelay: circleDrawDelay, location: CGPoint(x: width * 3 / 4 , y: height * 2 / 3) , size:120, left: false)
        let appsLabel = UILabel(frame: CGRect(x: 0,y: 0, width: width / 2, height: 30))
        appsLabel.center = CGPoint(x: width * 3 / 4 , y: bottomIconsHeightOffset)
        appsLabel.text = "My Apps"
        appsLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        appsLabel.textAlignment = NSTextAlignment.center
        appsLabel.strokeTextSimultaneously(0.4, delay: labelDrawDelay, duration: labelDrawDuration, fade: true)
        self.view.addSubview(appsLabel)
        
        myAppsButton = ForceTouchButton(frame: CGRect(x: 0,y: 0,width: 120,height: 120))
        myAppsButton.homeController  = self
        myAppsButton.center = CGPoint(x: width * 3 / 4, y: height * 2 / 3)
        myAppsButton.layer.cornerRadius = 60
        myAppsButton.addTarget(self, action: #selector(HomeViewController.goToMyApps), for: UIControlEvents.touchUpInside)
        myAppsButton.layer.masksToBounds = true
        myAppsButton.clipsToBounds = true
        self.view.addSubview(myAppsButton)
        
        //Welcome
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: width, height: 100))
        label.text = "Welcome"
        label.font = UIFont(name: "Panton-Regular", size: 40)
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        label.strokeTextAnimated(1.0, duration: 2, fade: true)
        
//        let hopeLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
////        let attributedString = NSMutableAttributedString(string: "Hope to see you at WWDC 2016!")
////        attributedString.addAttributes([NSFontAttributeName : UIFont(name: "Lato-Thin", size: 22)!], range: NSMakeRange(0, attributedString.length - 10))
////        attributedString.addAttributes([NSFontAttributeName : UIFont(name: "Lato-Regular", size: 24)!], range: NSMakeRange(attributedString.length - 10,4))
////        hopeLabel.attributedText = attributedString
//        hopeLabel.text = "Hope to see you at WWDC 2016!"
//        hopeLabel.textAlignment = .center
//        hopeLabel.font = UIFont(name: "Lato-Hairline", size: 24)
////        hopeLabel.font = UIFont(name: "Menlo-Regular", size: 22)
//        hopeLabel.layer.opacity = 0.0
//        self.view.addSubview(hopeLabel)
//        delay(4.0) { 
//            let charArray = hopeLabel.strokeTextSimultaneously(0.9, delay: 0.0, duration: 3.0, fade: false, returnStuff: true)
////            charArray.forEach{ $0.shadowColor = UIColor.blackColor().CGColor
////                $0.shadowRadius = 10
////                $0.shadowOpacity = 0.7
////            }
//            charArray[(charArray.count - 10)...(charArray.count - 1)].forEach { $0.lineWidth = 2.0 }
//            charArray[(charArray.count - 5)...(charArray.count - 1)].forEach { $0.strokeColor = UIColor(rgba: "#00ada2").cgColor }
//            charArray[charArray.count - 7].strokeColor = UIColor(rgba: "#dd3a36").cgColor
//            charArray[charArray.count - 8].strokeColor = UIColor(rgba: "#d18e5d").cgColor
//            charArray[charArray.count - 9].strokeColor = UIColor(rgba: "#b7379b").cgColor
//            charArray[charArray.count - 10].strokeColor = UIColor(rgba: "#93c56d").cgColor
//        }
//        
//        
        
        
        drawIcons()
    }
    
    func drawIcons() {
        //Info Icon
        let infoIconpath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 60, height: 75), cornerRadius: 3)
        infoIconpath.move(to: CGPoint(x: 10,y: 10))
        infoIconpath.addLine(to: CGPoint(x: 20, y: 10))
        infoIconpath.move(to: CGPoint(x: 17.5,y: 17))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 17))
        infoIconpath.move(to: CGPoint(x: 10,y: 24))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 24))
        infoIconpath.move(to: CGPoint(x: 10,y: 31))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 31))
        infoIconpath.move(to: CGPoint(x: 10,y: 38))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 38))
        infoIconpath.move(to: CGPoint(x: 10,y: 45))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 45))
        infoIconpath.move(to: CGPoint(x: 10,y: 52))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 52))
        infoIconpath.move(to: CGPoint(x: 40,y: 66))
        infoIconpath.addLine(to: CGPoint(x: 50, y: 66))
        
        let infoShape = CAShapeLayer()
        infoShape.path = infoIconpath.cgPath
        infoShape.strokeColor = UIColor.black.cgColor
        infoShape.lineWidth = 1.0
        infoShape.fillColor = nil
        var pointOffset = myInfoCircle!.path!.boundingBox.origin
        infoShape.position = CGPoint(x: pointOffset.x + 30, y: pointOffset.y + 23)
        myInfoCircle?.addSublayer(infoShape)
        
        //My Apps Icon
        let appsIconPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 75, height: 75), cornerRadius: 17)
        appsIconPath.move(to: CGPoint(x: 20.5, y: 12.0))
        appsIconPath.addArc(withCenter: CGPoint(x: 20.5, y: 24.5), radius: 12.5, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
        appsIconPath.move(to: CGPoint(x: 57, y: 7))
        appsIconPath.addLine(to: CGPoint(x: 72, y: 32))
        appsIconPath.addLine(to: CGPoint(x: 42, y: 32))
        appsIconPath.addLine(to: CGPoint(x: 57, y: 7))
        appsIconPath.move(to: CGPoint(x: 20.5, y: 42))
        appsIconPath.addLine(to: CGPoint(x: 32.5, y: 50.6))
        appsIconPath.addLine(to: CGPoint(x: 27.9, y: 64.6))
        appsIconPath.addLine(to: CGPoint(x: 13.1, y: 64.61))
        appsIconPath.addLine(to: CGPoint(x: 8.61, y: 50.6))
        appsIconPath.addLine(to: CGPoint(x: 20.5, y: 42))
        appsIconPath.move(to: CGPoint(x: 27, y: 27))
        appsIconPath.addLine(to: CGPoint(x: 57, y: 27))
        appsIconPath.addLine(to: CGPoint(x: 57, y: 57))
        appsIconPath.addLine(to: CGPoint(x: 27, y: 57))
        appsIconPath.addLine(to: CGPoint(x: 27, y: 27))
        
        let appsShape = CAShapeLayer()
        appsShape.path = appsIconPath.cgPath
        appsShape.strokeColor = UIColor.black.cgColor
        appsShape.lineWidth = 1.0
        appsShape.fillColor = nil
        pointOffset = myAppsCircle!.path!.boundingBox.origin
        appsShape.position = CGPoint(x: pointOffset.x + 23, y: pointOffset.y + 23)
        myAppsCircle?.addSublayer(appsShape)
        
        //My Story Icon
        let storyPath = UIBezierPath()
        
        storyPath.move(to: CGPoint(x: 20,y: 64.9))
        let storyPathPoints = [CGPoint(x: 20,y: 64.9), CGPoint(x: 43.36, y: 80.12), CGPoint(x: 64.83, y: 50.01), CGPoint(x: 82.3, y: 65.9), CGPoint(x: 102.2, y: 51.02)]
        
        let p2 = storyPathPoints[0]
        storyPath.move(to: CGPoint(x: p2.x, y: p2.y - 3))
        storyPath.addArc(withCenter: p2, radius: 3, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
        let pointArr = [CGPoint(x: p2.x, y: p2.y - 5), CGPoint(x: p2.x - 4, y: p2.y - 15), CGPoint(x: p2.x, y: p2.y - 23), CGPoint(x: p2.x + 4, y: p2.y - 15), CGPoint(x: p2.x, y: p2.y - 5)]
        storyPath.move(to: pointArr[0])
        for index in 1..<pointArr.count{
            let p1 = pointArr[index]
            storyPath.addLine(to: p1)
        }
        storyPath.move(to: p2)
        
        for index in 1..<storyPathPoints.count{
            let p2 = storyPathPoints[index]
            let p1 = storyPathPoints[index - 1]
            let midpoint = midpointOfPoints(p1, secondPoint: p2)
            storyPath.addQuadCurve(to: midpoint, controlPoint: controlPointForPoints(midpoint, p2: p1))
            storyPath.addQuadCurve(to: p2, controlPoint: controlPointForPoints(midpoint, p2: p2))
            storyPath.move(to: CGPoint(x: p2.x, y: p2.y - 3))
            storyPath.addArc(withCenter: p2, radius: 3, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI * 3 / 2 + 2 * M_PI), clockwise: true)
            let pointArr = [CGPoint(x: p2.x, y: p2.y - 5), CGPoint(x: p2.x - 4, y: p2.y - 15), CGPoint(x: p2.x, y: p2.y - 23), CGPoint(x: p2.x + 4, y: p2.y - 15), CGPoint(x: p2.x, y: p2.y - 5)]
            storyPath.move(to: pointArr[0])
            for index in 1..<pointArr.count{
                let p1 = pointArr[index]
                storyPath.addLine(to: p1)
            }
            storyPath.move(to: p2)
        }

        let storyShape = CAShapeLayer()
        storyShape.path = storyPath.cgPath
        storyShape.strokeColor = UIColor.black.cgColor
        storyShape.lineWidth = 1.0
        storyShape.fillColor = nil
        pointOffset = myStoryCircle!.path!.boundingBox.origin
        storyShape.position = pointOffset
        myStoryCircle?.addSublayer(storyShape)
        
        
        infoShape.lineWidth = 0.0
        appsShape.lineWidth = 0.0
        storyShape.lineWidth = 0.0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = NSNumber(value: 0.0 as Float)
        strokeAnimation.toValue = NSNumber(value: 1.0 as Float)
        strokeAnimation.duration = 5.0
        delay(1.5) {
            infoShape.lineWidth = 1.0
            appsShape.lineWidth = 1.0
            storyShape.lineWidth = 1.0
            
            infoShape.add(strokeAnimation, forKey: "Stroke Animation")
            appsShape.add(strokeAnimation, forKey: "Stroke Animation")
            storyShape.add(strokeAnimation, forKey: "Stroke Animation")
        }
    }
    
    fileprivate func midpointOfPoints(_ firstPoint: CGPoint, secondPoint:CGPoint)->CGPoint{
        return CGPoint(x: (firstPoint.x + secondPoint.x) / 2, y: (firstPoint.y + secondPoint.y) / 2)
    }
    
    fileprivate func controlPointForPoints(_ p1: CGPoint, p2: CGPoint)-> CGPoint{
        var controlPoint = midpointOfPoints(p1, secondPoint: p2)
        let diffy = abs((p2.y - controlPoint.y))
        if p1.y < p2.y {
            controlPoint.y += diffy
        }else if p1.y > p2.y{
            controlPoint.y  -= diffy
        }
        return controlPoint
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if animationFlag == .stop && lastState != nil{
            animationFlag = lastState!
            startAnimation()
        }
    }
    var myStoryCircle: CAShapeLayer?
    var myInfoCircle: CAShapeLayer?
    var myAppsCircle: CAShapeLayer?
    
    //Drawing the circle from the side
    func createLineCircle(_ delayt: Double, duration: Double, fadeDelay:Double, location: CGPoint, size: CGFloat, left: Bool)->CAShapeLayer{
        let line = CAShapeLayer()
        line.position = CGPoint(x: 0, y: 0)
        line.lineWidth = 0
        line.strokeColor = UIColor.black.cgColor
        line.fillColor = UIColor.clear.cgColor
        
        let path = CGMutablePath()
        
        var points = Array<CGPoint>()
        if left {
            points = Array(arrayLiteral: CGPoint(x: 0,y: location.y - size / 2),CGPoint(x: location.x,y: location.y - size / 2))
        }else{
            points = Array(arrayLiteral: CGPoint(x: self.view.frame.width,y: location.y - size / 2),CGPoint(x: location.x,y: location.y - size / 2))
        }
        //MARK - Updated with Swift 3 - check
        path.addLines(between: points)
//        CGPathAddLines(path, nil, points, 2)
        var circlePath: CGPath?
        if left {
            circlePath = UIBezierPath(roundedRect: CGRect(x: location.x - size / 2,y: location.y - size / 2, width: size, height: size), cornerRadius: size).cgPath
        }else {
            circlePath = UIBezierPath(roundedRect: CGRect(x: location.x - size / 2,y: location.y - size / 2, width: size, height: size), cornerRadius: size).reversing().cgPath
        }
        //MARK - Updated with Swift 3 - check 
        path.addPath(circlePath!)
//        CGPathAddPath(path, nil, circlePath!)
        line.path  = path
        
        let circle = CAShapeLayer()
        circle.path = circlePath
        circle.position = CGPoint(x: 0, y: 0)
        circle.lineWidth = 0
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.black.cgColor
        self.view.layer.addSublayer(circle)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = NSNumber(value: 0.0 as Float)
        drawAnimation.toValue = NSNumber(value: 1.0 as Float)
        drawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let undrawAnimation = CABasicAnimation(keyPath: "strokeStart")
        undrawAnimation.duration = duration * 2
        undrawAnimation.repeatCount = 1
        undrawAnimation.fromValue = NSNumber(value: 0.0 as Float)
        undrawAnimation.toValue = NSNumber(value: 1.0 as Float)
        undrawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.view.layer.addSublayer(line)
        
        delay(delayt) { () -> () in
            line.lineWidth = 2
            line.add(drawAnimation, forKey: "drawLineAnimation")
            self.delay(fadeDelay, closure: { () -> () in
                line.add(undrawAnimation, forKey: "undrawLineAnimation")
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
        UIView.animate(withDuration: 4.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            if self.animationFlag == .down {
                self.bgScroll!.frame.origin.y = -self.bgScroll!.frame.height + UIScreen.main.bounds.height
                self.bgScroll2!.frame.origin.y = -self.bgScroll2!.frame.height + UIScreen.main.bounds.height
                self.animationFlag = .up
            } else if self.animationFlag == .up {
                self.bgScroll!.frame.origin.y = 0
                self.bgScroll2!.frame.origin.y = 0
                self.animationFlag = .down
            }
            self.lastState = self.animationFlag
            }, completion: { (finished: Bool) in
                if self.animationFlag != .stop{
                    UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions(), animations: {
                            if self.animationFlag == .up{
                                if self.bgNumFlag == .first{
                                    self.bgScroll!.alpha = 0.0
                                    self.bgScroll2!.image = self.randomizedBGColor()
                                    self.bgScroll2!.alpha = 1.0
                                    self.bgNumFlag = .second
                                }else{
                                    self.bgScroll!.image = self.randomizedBGColor()
                                    self.bgScroll!.alpha = 1.0
                                    self.bgScroll2!.alpha = 0.0
                                    self.bgNumFlag = .first
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
        arr.append(firstColor.cgColor)
        var rand2 = arc4random() >> 1
        var randNum2 = Int(rand2) % bgColors.count
        while randNum2 == randNum {
            rand2 = arc4random() >> 1
            randNum2 = Int(rand2) % bgColors.count
        }
        let secondColor = bgColors[randNum2]
        arr.append(secondColor.cgColor)
        return arr
    }
    //Single gradient from random colors
    func randomizedBGColor()->UIImage{
        let gradient = CAGradientLayer()
        gradient.backgroundColor = UIColor.green.cgColor
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 2)
        gradient.colors = randomizedColorSet()
        let image = imageFromLayer(gradient)
        return image
    }
    
    //Gradient layer to image
    func imageFromLayer(_ layer:CALayer) -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    var displayingDetailForButtons = false
    
    func forceTouchDetected(_ touch:UITouch, button:ForceTouchButton){
        let location = touch.location(in: self.view)
        if touch.force >= touch.maximumPossibleForce * 0.8 && displayingDetailForButtons == false{
            if myStoryButton.frame.contains(location){
                displayDetailForceTouch("Want to know what I've been up to for the past four years?", type: 0)
                displayingDetailForButtons = true
            }else if myInfoButton.frame.contains(location){
                displayDetailForceTouch("Want some extra info?  Contact Info, Education, Hobbies, and more.", type: 1)
                displayingDetailForButtons = true
            }else if myAppsButton.frame.contains(location){
                displayDetailForceTouch("Want to see the apps I've made? See the projects I take pride in.", type: 2)
                displayingDetailForButtons = true
            }
        }
        
        
    }
    
    func displayDetailForceTouch(_ text:String, type: Int){
        let popUpView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width * 0.7, height: 250))
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        popUpView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 40)
        popUpView.backgroundColor = UIColor.white
        popUpView.alpha = 0.0
        self.view.addSubview(popUpView)
        UIView.animate(withDuration: 0.5, animations: { 
            popUpView.center = self.view.center
            popUpView.alpha = 1.0
        }) 
        
        let textLabel = UILabel(frame: CGRect(x: 25,y: 0,width: popUpView.frame.width - 50, height: 150))
        textLabel.text = text
        textLabel.font = UIFont(name: "Panton-Thin", size: 20)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        popUpView.addSubview(textLabel)
        textLabel.strokeTextLetterByLetter(0.6, delay: 0.0, duration: 1.5, characterStrokeDuration: 0.5, fade: false, returnStuff: false)
        
        let openButton = UIButton(frame: CGRect(x: 0,y: 150,width: popUpView.frame.width, height: 50))
        openButton.setTitle("Check it out", for: UIControlState())
        openButton.backgroundColor = UIColor(rgba: "#1aada5")
        openButton.tag = type
        openButton.addTarget(self, action: #selector(HomeViewController.openFromDetailForceTouch(_:)), for: .touchUpInside)
        
        
        popUpView.addSubview(openButton)
        
        let dismissButton = UIButton(frame: CGRect(x: 0,y: 200,width: popUpView.frame.width, height: 50))
        dismissButton.setTitle("Maybe Later", for: UIControlState())
        dismissButton.backgroundColor = UIColor(rgba: "#da3e41")
        dismissButton.addTarget(self, action: #selector(HomeViewController.dismissDetailForceTouch(_:notAnimated:)), for: .touchUpInside)
        popUpView.addSubview(dismissButton)

        
        openButton.alpha = 0.0
        dismissButton.alpha = 0.0
        openButton.center = CGPoint(x: openButton.center.x, y: openButton.center.y + 50)
        dismissButton.center = CGPoint(x: dismissButton.center.x, y: dismissButton.center.y + 50)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
            openButton.alpha = 1.0
            openButton.center = CGPoint(x: openButton.center.x, y: openButton.center.y - 50)
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.25, options: .curveEaseOut, animations: {
            dismissButton.alpha = 1.0
            dismissButton.center = CGPoint(x: dismissButton.center.x, y: dismissButton.center.y - 50)
            }, completion: nil)
    }
    
    func openFromDetailForceTouch(_ view:UIView){
        switch view.tag {
        case 0:
            dismissDetailForceTouch(view,notAnimated: true)
            self.goToMyStory()
        case 1:
            dismissDetailForceTouch(view,notAnimated: true)
            self.goToMyInfo()
        case 2:
            dismissDetailForceTouch(view,notAnimated: true)
            self.goToMyApps()
        default:
            print("Something went wrong :( ")
        }
    }
    
    func dismissDetailForceTouch(_ view:UIView, notAnimated:Bool = false){
        self.displayingDetailForButtons = false
        UIView.animate(withDuration: 0.5, animations: {
            if notAnimated == false{
                view.superview?.center = CGPoint(x: (view.superview?.center.x)!, y: (view.superview?.center.y)! - 60)
            }
            view.superview?.alpha = 0.0
            }, completion: { (finished) in
                view.superview?.removeFromSuperview()
        }) 
        
    }
    
    // MARK: - Navigation
    func goToMyStory(){
        if displayingDetailForButtons == true{
            return
        }
        self.animationFlag = .stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myStoryTVC = storyboard.instantiateViewController(withIdentifier: "MyStoryVC")
        self.navigationController?.pushViewController(myStoryTVC, animated: true)
    }
    
    func goToMyInfo(){
        if displayingDetailForButtons == true{
            return
        }
        self.animationFlag = .stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myInfoTVC = storyboard.instantiateViewController(withIdentifier: "MyInfoVC")
        self.navigationController?.pushViewController(myInfoTVC, animated: true)
        
    }
    
    func goToMyApps(){
        if displayingDetailForButtons == true{
            return
        }
        self.animationFlag = .stop
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAppsTVC = storyboard.instantiateViewController(withIdentifier: "MyAppsTVC")
        self.navigationController?.pushViewController(myAppsTVC, animated: true)
        
    }
    
}

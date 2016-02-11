//
//  HomeViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 2/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

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
    
    var bgScroll:UIImageView?
    var bgScroll2:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        bgScroll = UIImageView(frame: CGRectMake(0, 0, width, height * 2))
        bgScroll?.alpha = 0
        bgScroll?.contentMode = UIViewContentMode.ScaleAspectFill
        bgScroll?.image = UIImage(named: "bg")
        self.view.addSubview(bgScroll!)
        
        bgScroll2 = UIImageView(frame: CGRectMake(0, 0, width, height * 2))
        bgScroll2?.alpha = 0
        bgScroll2?.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bgScroll2!)
        
        
        
        UIView.animateWithDuration(2, delay: 5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bgScroll?.alpha = 1.0
        }, completion: nil)
        delay(5.0) { () -> () in
            self.startAnimation()
        }
        
        
        let detailFontSize = CGFloat(25)
        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width / 2 , height / 3) , size:120, left: true)
        let storyLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        storyLabel.center = CGPointMake(width / 2 , height / 3 + 60 + 20)
        storyLabel.text = "My Story"
        storyLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        storyLabel.textAlignment = NSTextAlignment.Center
        storyLabel.drawOutlineAnimatedWithLineWidth(0.4, withDuration: 1.0, withDelay: 4, fadeToLabel: true)
        self.view.addSubview(storyLabel)
        
        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width / 4 , height * 2 / 3) , size:120, left: true)
        let infoLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        infoLabel.center = CGPointMake(width / 4 , height * 2 / 3 + 60 + 20)
        infoLabel.text = "My Info"
        infoLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.drawOutlineAnimatedWithLineWidth(0.4, withDuration: 1.0, withDelay: 4, fadeToLabel: true)
        self.view.addSubview(infoLabel)
        
        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width * 3 / 4 , height * 2 / 3) , size:120, left: false)
        let appsLabel = UILabel(frame: CGRectMake(0,0, width / 2, 30))
        appsLabel.center = CGPointMake(width * 3 / 4 , height * 2 / 3 + 60 + 20)
        appsLabel.text = "My Apps"
        appsLabel.font = UIFont(name: "Panton-Light", size: detailFontSize)
        appsLabel.textAlignment = NSTextAlignment.Center
        appsLabel.drawOutlineAnimatedWithLineWidth(0.4, withDuration: 1.0, withDelay: 4, fadeToLabel: true)
        self.view.addSubview(appsLabel)
        
        let label = UILabel(frame: CGRectMake(0,0,width, 100))
        label.text = "Welcome"
        label.font = UIFont(name: "Panton-Regular", size: 40)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        label.drawOutlineAnimatedWithLineWidth(1.0, withDuration: 2, fadeToLabel: true)
        
        
        
        // Do any additional setup after loading the view.
    }
    
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
        let circlePath = UIBezierPath(roundedRect: CGRectMake(location.x - size / 2,location.y - size / 2, size, size), cornerRadius: size).CGPath
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
    
    func startAnimation () {
        UIView.animateWithDuration(5.0, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            [weak self] in
            if let strongSelf = self {
                if strongSelf.animationFlag == .Down {
                    strongSelf.bgScroll!.frame.origin.y = -strongSelf.bgScroll!.frame.height + UIScreen.mainScreen().bounds.height
                    strongSelf.bgScroll2!.frame.origin.y = -strongSelf.bgScroll2!.frame.height + UIScreen.mainScreen().bounds.height
                    strongSelf.animationFlag = .Up
                } else if strongSelf.animationFlag == .Up {
                    strongSelf.bgScroll!.frame.origin.y = 0
                    strongSelf.bgScroll2!.frame.origin.y = 0
                    strongSelf.animationFlag = .Down
                }
            }
            }, completion: { [weak self] finished in
                if self?.animationFlag != .Stop{
                    UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {[weak self] in
                        if let strongSelf = self {
                            if self?.animationFlag == .Up{
                                if strongSelf.bgNumFlag == .First{
                                    strongSelf.bgScroll!.alpha = 0.0
                                    strongSelf.bgScroll2!.image = strongSelf.randomizedBGColor()
                                    strongSelf.bgScroll2!.alpha = 1.0
                                    strongSelf.bgNumFlag = .Second
                                }else{
                                    strongSelf.bgScroll!.image = strongSelf.randomizedBGColor()
                                    strongSelf.bgScroll!.alpha = 1.0
                                    strongSelf.bgScroll2!.alpha = 0.0
                                    strongSelf.bgNumFlag = .First
                                }
                            }
                        }
                        }, completion: { [weak self] finished in
                            self?.startAnimation()
                    })
                }
            })
    }
    
    var bgColors = Array<UIColor>(arrayLiteral: UIColor(hex6: 0xfc515a),UIColor(hex6: 0xe6a14b),UIColor(hex6: 0xfc5e6f),UIColor(hex6: 0xf3b93e),UIColor(hex6: 0x62cbfa),UIColor(hex6: 0xd08ab4),UIColor(hex6: 0xb8fbb4),UIColor(hex6: 0x2ffbfc))
    
    func randomizedColorSet() -> Array<CGColor>{
        var arr = Array<CGColor>()
        let firstColor = bgColors[Int(arc4random()) % bgColors.count]
        arr.append(firstColor.CGColor)
        let secondColor = bgColors[Int(arc4random()) % bgColors.count]
        arr.append(secondColor.CGColor)
        return arr
    }
    
    func randomizedBGColor()->UIImage{
        let gradient = CAGradientLayer()
        gradient.backgroundColor = UIColor.greenColor().CGColor
        gradient.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 2)
        gradient.colors = randomizedColorSet()
        let image = imageFromLayer(gradient)
        return image
        
    }
    
    func imageFromLayer(layer:CALayer) -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
    //    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    //    btnGradient.frame = CGRectMake(0,0, gameScore.frame.size.width, gameScore.frame.size.height);
    //    btnGradient.colors = [NSArray arrayWithObjects:
    //    (id)[[UIColor colorWithRed:10.0f / 255.0f green:19.0f / 255.0f blue:190.0f / 255.0f alpha:1.0f] CGColor],(id)[[UIColor colorWithRed:38.0f / 255.0f green:29.0f / 232.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],(id)[[UIColor colorWithRed:38.0f / 255.0f green:29.0f / 232.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],(id)[[UIColor colorWithRed:38.0f / 255.0f green:29.0f / 232.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],(id)[[UIColor colorWithRed:10.0f / 255.0f green:19.0f / 255.0f blue:190.0f / 255.0f alpha:1.0f] CGColor],                                          nil];
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

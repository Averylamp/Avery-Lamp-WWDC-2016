//
//  HomeViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 2/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let height = self.view.frame.height
        let width = self.view.frame.width

        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width / 2 , height / 3) , size:120, left: true)
        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width / 4 , height * 2 / 3) , size:120, left: true)
        createLineCircle(0, duration: 2.0, fadeDelay: 2.0, location: CGPointMake(width * 3 / 4 , height * 2 / 3) , size:120, left: false)
        
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

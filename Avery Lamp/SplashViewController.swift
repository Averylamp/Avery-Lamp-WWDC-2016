//
//  SplashViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 1/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit



class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg.image = UIImage(named: "NewYorkBackground")
        bg.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bg)
        bg.alpha = 0.0
        
        let bg2 = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg2.image = UIImage(named: "NewYorkBackground")
        bg2.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bg2)
        bg2.alpha = 0.0

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg2.bounds
        bg2.addSubview(blurEffectView)
        
        // Vibrancy Effect
        
        let bg3 = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg3.image = UIImage(named: "NewYorkBackground2")
        bg3.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = bg3.bounds
        vibrancyEffectView.contentView.addSubview(bg3)
        
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            bg.alpha = 1.0
            }) { (finished) -> Void in
                UIView.animateWithDuration(2, animations: { () -> Void in
                    bg2.alpha = 1.0
                })
        }
        
        let welcomeLabel  = UILabel(frame: CGRectMake(0,self.view.frame.height / 12 ,self.view.frame.width, 100))
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = UIFont(name: "Panton-Thin", size: 30)
        self.view.addSubview(welcomeLabel)
        welcomeLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 1, fadeToLabel: false)
        
        
        let myNameLabel  = UILabel(frame: CGRectMake(0,self.view.frame.height * 1 / 2  - 50 ,self.view.frame.width, 40))
        myNameLabel.text = "My name is Avery"
        myNameLabel.font = UIFont(name: "Panton-Thin", size: 20)
        self.view.addSubview(myNameLabel)
        myNameLabel.drawOutlineAnimatedWithLineWidth(0.7, withDuration: 2, withDelay: 2, fadeToLabel: false);
        
        
        let picSize = myNameLabel.frame.origin.y - welcomeLabel.frame.origin.y - 100
        let proPic = UIImageView(frame: CGRectMake(0, 0, picSize, picSize))
        proPic.image = UIImage(named: "Headshot")
        proPic.center = CGPointMake(self.view.center.x, welcomeLabel.frame.origin.y + welcomeLabel.frame.height + picSize / 2 + 50)
        proPic.layer.cornerRadius = picSize / 2
//        proPic.layer.borderWidth = 1
        proPic.layer.masksToBounds = true
        proPic.alpha = 0.0
        self.view.addSubview(proPic)
        
        
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(roundedRect: CGRectMake(0,0, picSize, picSize), cornerRadius: picSize).CGPath
        circle.position = CGPointMake(0, 0)
        circle.lineWidth = 0
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor.blackColor().CGColor
        proPic.layer.addSublayer(circle)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 3
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = NSNumber(float: 0.0)
        drawAnimation.toValue = NSNumber(float: 1.0)
        drawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        delay(2.5) { () -> () in
            circle.lineWidth = 2
            circle.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
        }
        
        UIView.animateWithDuration(1.5, delay: 2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            proPic.alpha = 1.0
            }) { (finished) -> Void in}
       
        let shimmerView = FBShimmeringView(frame: CGRectMake(0,self.view.frame.height * 5 / 6,self.view.frame.width, 60))
        shimmerView.alpha = 1.0
        self.view.addSubview(shimmerView)
        let continueLabel = UILabel(frame: shimmerView.frame)
        continueLabel.text = "Continue"
        continueLabel.font = UIFont(name: "Panton-Light", size: 24)
        continueLabel.textColor = UIColor.whiteColor()
        continueLabel.textAlignment = NSTextAlignment.Center
        shimmerView.contentView = continueLabel
        shimmerView.shimmering = true
        continueLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 1, withDelay: 5, fadeToLabel: true)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    func addProPic(){
        
        
        
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

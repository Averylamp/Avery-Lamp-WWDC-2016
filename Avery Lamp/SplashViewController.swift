//
//  SplashViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 1/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit



class SplashViewController: UIViewController {

    var continuable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg.image = UIImage(named: "NewYorkBackground")
        bg.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bg)
        bg.alpha = 0.0
        
        let bg2 = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        bg2.image = UIImage(named: "NewYorkBackground3")
        bg2.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bg2)
        bg2.alpha = 0.0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg2.bounds
        blurEffectView.alpha = 0.0
        self.view.addSubview(blurEffectView)
        
        
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            bg.alpha = 1.0
            }) { (finished) -> Void in
                UIView.animateWithDuration(4, animations: { () -> Void in
                    bg2.alpha = 1.0
                    blurEffectView.alpha = 1.0
                    bg.alpha = 1.0
                })
        }
        
        let welcomeLabel  = UILabel(frame: CGRectMake(0,self.view.frame.height / 12 ,self.view.frame.width, 100))
        welcomeLabel.text = "Hello"
        welcomeLabel.font = UIFont(name: "Panton-Light", size: 30)
        self.view.addSubview(welcomeLabel)
        welcomeLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 3, fadeToLabel: true)
        
        
        let myNameLabel  = UILabel(frame: CGRectMake(0,self.view.frame.height * 1 / 2 ,self.view.frame.width, 40))
        myNameLabel.text = "My name is Avery"
        myNameLabel.font = UIFont(name: "Panton-Light", size: 20)
        self.view.addSubview(myNameLabel)
        myNameLabel.drawOutlineAnimatedWithLineWidth(0.7, withDuration: 2, withDelay: 4, fadeToLabel: true);
        
        
        let picSize = myNameLabel.frame.origin.y - welcomeLabel.frame.origin.y - welcomeLabel.frame.height - 50
        let proPic = UIImageView(frame: CGRectMake(0, 0, picSize, picSize))
        proPic.image = UIImage(named: "Headshot2")
        proPic.center = CGPointMake(self.view.center.x, welcomeLabel.frame.origin.y + welcomeLabel.frame.height + picSize / 2 + 25)
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
        circle.strokeColor = UIColor.whiteColor().CGColor
        proPic.layer.addSublayer(circle)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 3
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = NSNumber(float: 0.0)
        drawAnimation.toValue = NSNumber(float: 1.0)
        drawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        delay(4.5) { () -> () in
            circle.lineWidth = 3
            circle.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
            self.delay(3.5, closure: { () -> () in
                self.continuable = true
            })
        }
        
        UIView.animateWithDuration(2.5, delay: 4.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            proPic.alpha = 1.0
            }) { (finished) -> Void in}
       
        let shimmerView = FBShimmeringView(frame: CGRectMake(0,self.view.frame.height * 5 / 6,self.view.frame.width, 60))
        shimmerView.center = CGPointMake(self.view.center.x, self.view.frame.height * 5 / 6)
        shimmerView.alpha = 1.0
        shimmerView.shimmeringSpeed = 100
        shimmerView.shimmeringPauseDuration = 0.1
        shimmerView.shimmeringHighlightLength = 0.5
        self.view.addSubview(shimmerView)
        let continueLabel = UILabel(frame: shimmerView.frame)
        continueLabel.text = "Tap Anywhere to Continue"
        continueLabel.font = UIFont(name: "Panton-Regular", size: 24)
        continueLabel.textColor = UIColor.whiteColor()
        continueLabel.textAlignment = NSTextAlignment.Center
        shimmerView.contentView = continueLabel
        shimmerView.shimmering = true
        continueLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 1, withDelay: 8, fadeToLabel: true)
        
        
        
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if continuable {
            print("Populating images")
            populateImages()
            let location = touches.first?.locationInView(self.view)
            let h = Int((location?.x)! / imageSize)
            let v = Int((location?.y)! / imageSize)
            print("h - \(h)  v - \(v)")

            rippleTransitionSetup(imgViews, h: h, v: v, iteration: 0)
            
            for v in 0...vertPics - 1 {
                for h in 0...horzPics - 1 {
                    
//                    print("h - \(h)  v - \(v) tag - \(imgViews[v][h].tag - 1000)")
                    rippleFade2(imgViews[v][h], delays: Double(imgViews[v][h].tag - 1000) * 0.1)
                    
                }
            }
        }
        
    }
    
    var images = Array<Array<UIImage>>()
    var imgViews = Array<Array<UIImageView>>()
    var fullImage: UIImage?
    var horzPics = 0
    var vertPics = 0
    let imageSize = CGFloat(20.0)
    
    func populateImages(){
        
        
        let size = self.view.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let rec = CGRectMake(0, 0, size.width, size.height)
        self.view.drawViewHierarchyInRect(rec, afterScreenUpdates: true)
        fullImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        horzPics = Int(ceil(size.width / imageSize))
        vertPics = Int(ceil(size.height / imageSize))
        
        images = Array<Array<UIImage>>()
        imgViews = Array<Array<UIImageView>>()
        for _ in 0...vertPics - 1 {
            images.append(Array(count: horzPics, repeatedValue: UIImage()))
            imgViews.append(Array(count: horzPics, repeatedValue: UIImageView()))
        }
        
        for v in 0...vertPics - 1 {
            for h in 0...horzPics - 1 {
                images[v][h] = croppedImage(fullImage!, cropRect: CGRectMake(CGFloat(h) * imageSize * UIScreen.mainScreen().scale,CGFloat(v) * imageSize * UIScreen.mainScreen().scale,imageSize * UIScreen.mainScreen().scale,imageSize * UIScreen.mainScreen().scale))
                
            }
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        for v in 0...vertPics - 1 {
            for h in 0...horzPics - 1 {
                let imgView = UIImageView(frame: CGRectMake(CGFloat(h) * imageSize, CGFloat(v) * imageSize , images[v][h].size.width / UIScreen.mainScreen().scale, images[v][h].size.height / UIScreen.mainScreen().scale))

                self.view.addSubview(imgView)
                imgView.image = images[v][h]
                imgViews[v][h] = imgView
                imgView.alpha = 1.0
            }
        }
        
    }
    
    func croppedImage(image: UIImage, cropRect: CGRect) -> UIImage {
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)
        return UIImage(CGImage: imageRef!)
    }
    
    func rippleTransitionSetup(images: [[UIImageView]], h: Int, v: Int, iteration:Int){
        if (h < 0 || h >= images.first?.count || v < 0 || v >= images.count){
            return
        }
        if (images[v][h].tag >= 1000){
            if 1000 + iteration < images[v][h].tag {
                images[v][h].tag = 1000 + iteration
            }else{
                return
            }
        }else{
            images[v][h].tag = 1000 + iteration
        }
//        print("h - \(h)  v - \(v) delay - \(Double(iteration) * 0.1)")
//        rippleFade(images[v][h], delays: Double(iteration) * 0.1)
        
        rippleTransitionSetup(images, h: h - 1, v: v, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h + 1, v: v, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h, v: v - 1, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h, v: v + 1, iteration: iteration + 1)
    }
    
    func rippleFade(image : UIImageView, delays : Double) {

//        UIView.animateWithDuration(delays, animations: { () -> Void in
//            
//            }) { (finished) -> Void in
//                UIView.animateWithDuration(1.0, animations: { () -> Void in
//                    image.alpha = 0.0
//                })
//        }
        delay(delays) { () -> () in
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                image.alpha = 0.0
            })
        }
    }
    
    func rippleFade2(image : UIImageView, delays : Double) {
        delay(delays) { () -> () in
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                image.transform = CGAffineTransformMakeScale(0.15, 0.15)
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.8, animations: { () -> Void in
                        image.alpha = 0.0
                    })
            })
            
        }
        
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
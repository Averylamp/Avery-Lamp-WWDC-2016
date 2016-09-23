//
//  SplashViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
import Shimmer
//import LTMorphingLabel
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class SplashViewController: UIViewController {

    var continuable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //Background Blur effects
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        bg.image = UIImage(named: "NewYorkBackground")
        bg.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(bg)
        bg.alpha = 0.0
        
        let bg2 = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        bg2.image = UIImage(named: "NewYorkBackground3")
        bg2.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(bg2)
        bg2.alpha = 0.0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bg2.bounds
        blurEffectView.alpha = 0.0
        self.view.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            bg.alpha = 1.0
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 4, animations: { () -> Void in
                    bg2.alpha = 1.0
                    blurEffectView.alpha = 1.0
                    bg.alpha = 1.0
                })
        }) 
        
        //Label Drawing
        let welcomeLabel  = UILabel(frame: CGRect(x: 0,y: self.view.frame.height / 12 ,width: self.view.frame.width, height: 100))
        welcomeLabel.text = "Hello"
        welcomeLabel.font = UIFont(name: "Panton-Light", size: 30)
        self.view.addSubview(welcomeLabel)
//        welcomeLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 2, fadeToLabel: true)
        welcomeLabel.strokeTextAnimated(0.7, delay: 0.0, duration: 1, fade: false)
        delay(1.0) {
            UIView.animate(withDuration: 1.0, animations: {
                welcomeLabel.layer.opacity = 1.0
            })
        }
        
        
        let myNameLabel  = UILabel(frame: CGRect(x: 0,y: self.view.frame.height * 1 / 2 ,width: self.view.frame.width, height: 40))
        myNameLabel.text = "My name is Avery Lamp"
        myNameLabel.font = UIFont(name: "Panton-Light", size: 20)
        self.view.addSubview(myNameLabel)

        myNameLabel.strokeTextAnimated(0.6, delay: 1.0, duration: 1.5, fade: false)
        delay(2.5) { 
            UIView.animate(withDuration: 1.0, animations: { 
                myNameLabel.layer.opacity = 1.0
            })
        }
        
        let thankYouLabel1 = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 30))
        thankYouLabel1.text = "Thank you for reviewing my app!"
        thankYouLabel1.center = CGPoint(x: myNameLabel.center.x , y: myNameLabel.center.y + 50)
        thankYouLabel1.textAlignment = .center
        thankYouLabel1.font = UIFont(name: "Panton-Light", size: 16)
        self.view.addSubview(thankYouLabel1)
        thankYouLabel1.strokeTextLetterByLetter(0.6, delay: 3.5, duration: 2.0, characterStrokeDuration: 1.0, fade: false, fadeDuration: 1.0, returnStuff: false)
//        thankYouLabel1.strokeTextSimultaneously(width: 0.6, delay: 3.5, duration: 2.0, fade: false)
      
        let thankYouLabel2 = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 50))
        thankYouLabel2.text = "I hope you enjoy it!"
        thankYouLabel2.center = CGPoint(x: myNameLabel.center.x , y: myNameLabel.center.y + 80)
        thankYouLabel2.textAlignment = .center
        thankYouLabel2.font = UIFont(name: "Panton-Light", size: 16)
        self.view.addSubview(thankYouLabel2)
//        thankYouLabel2.strokeTextSimultaneously(width: 0.6, delay: 5.0, duration: 2.0, fade: false)
        thankYouLabel2.strokeTextLetterByLetter(0.6, delay: 4.5, duration: 2.0, characterStrokeDuration: 0.5, fade: false, fadeDuration: 1.0, returnStuff: false)
        
        
        //Picture
        let picSize = myNameLabel.frame.origin.y - welcomeLabel.frame.origin.y - welcomeLabel.frame.height - 50
        let proPic = UIImageView(frame: CGRect(x: 0, y: 0, width: picSize, height: picSize))
        proPic.image = UIImage(named: "Headshot2")
        proPic.center = CGPoint(x: self.view.center.x, y: welcomeLabel.frame.origin.y + welcomeLabel.frame.height + picSize / 2 + 25)
        proPic.layer.cornerRadius = picSize / 2
        proPic.layer.masksToBounds = true
        proPic.alpha = 0.0
        self.view.addSubview(proPic)
        
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(roundedRect: CGRect(x: 0,y: 0, width: picSize, height: picSize), cornerRadius: picSize).cgPath
        circle.position = CGPoint(x: 0, y: 0)
        circle.lineWidth = 0
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        proPic.layer.addSublayer(circle)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 3
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = NSNumber(value: 0.0 as Float)
        drawAnimation.toValue = NSNumber(value: 1.0 as Float)
        drawAnimation.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        delay(2.5) { () -> () in
            circle.lineWidth = 3
            circle.add(drawAnimation, forKey: "drawCircleAnimation")
            self.delay(2.0, closure: { () -> () in
                self.continuable = true
            })
        }
        
        UIView.animate(withDuration: 2.5, delay: 1.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            proPic.alpha = 1.0
            }) { (finished) -> Void in}
       
        //Shimmering Continue
        let shimmerView = FBShimmeringView(frame: CGRect(x: 0,y: self.view.frame.height * 5 / 6,width: self.view.frame.width, height: 60))
        shimmerView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height * 5 / 6)
        shimmerView.alpha = 1.0
        shimmerView.shimmeringSpeed = 100
        shimmerView.shimmeringPauseDuration = 0.1
        shimmerView.shimmeringHighlightLength = 0.5
        self.view.addSubview(shimmerView)
        let continueLabel = LTMorphingLabel(frame: shimmerView.frame)
        continueLabel.text = "Tap"
        continueLabel.morphingEffect = .fall
        continueLabel.morphingDuration = 1.8
        continueLabel.font = UIFont(name: "Panton-Regular", size: 24)
        continueLabel.textColor = UIColor.white
        continueLabel.textAlignment = NSTextAlignment.center
        shimmerView.contentView = continueLabel
        shimmerView.isShimmering = true
        continueLabel.alpha = 0.0
        delay(4.0) {
            shimmerView.addSubview(continueLabel)
            continueLabel.alpha = 1.0
            continueLabel.text = "Tap to Continue"
        }
        
//        continueLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 1, withDelay: 5, fadeToLabel: true)
        
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if continuable {
            continuable = false
            //calculate
            
            populateImages()
            let location = touches.first?.location(in: self.view)
            let h = Int((location?.x)! / imageSize)
            let v = Int((location?.y)! / imageSize)
            
        
            //Touch Circle
            let touchFeedback = UIView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
            touchFeedback.backgroundColor = UIColor.white
            touchFeedback.layer.cornerRadius = 25
            touchFeedback.center = location!
            touchFeedback.alpha = 0.4
            self.view.addSubview(touchFeedback)
            UIView.animate(withDuration: 0.5 , animations: {
                touchFeedback.transform = CGAffineTransform(scaleX: 2, y: 2)
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.1, animations: { 
                        touchFeedback.alpha = 0.0
                        }, completion: nil)
            })
            
            let queue = DispatchQueue(label: "flood", attributes: [])
            queue.async(execute: {
                self.rippleTransitionSetup(self.imgViews, h: h, v: v, iteration: 0)
            
            
            
            var max = 0
            for v in 0...self.vertPics - 1 {
                for h in 0...self.horzPics - 1 {
                    self.rippleFade2(self.imgViews[v][h], delays: Double(self.imgViews[v][h].tag - 1000) * 0.07)
                    if self.imgViews[v][h].tag - 1000 > max{
                        max = self.imgViews[v][h].tag - 1000
                    }
                }
            }
                
             
            self.delay(Double(max) * 0.1 + 2, closure: { () -> () in
                self.navigationController?.pushViewController(HomeViewController(), animated: false)
            })
            })
        }
        
    }
    
    var images = Array<Array<UIImage>>()
    var imgViews = Array<Array<UIImageView>>()
    var fullImage: UIImage?
    var horzPics = 0
    var vertPics = 0
    let imageSize = CGFloat(30.0)
    
    func populateImages(){
        
        let size = self.view.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let rec = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.view.drawHierarchy(in: rec, afterScreenUpdates: true)
        fullImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        horzPics = Int(ceil(size.width / imageSize))
        vertPics = Int(ceil(size.height / imageSize))
        
        //Create 2d arrays
        images = Array<Array<UIImage>>()
        imgViews = Array<Array<UIImageView>>()
        for _ in 0...vertPics - 1 {
            images.append(Array(repeating: UIImage(), count: horzPics))
            imgViews.append(Array(repeating: UIImageView(), count: horzPics))
        }
        
        //Add cropped images to 2d arrays
        for v in 0...vertPics - 1 {
            for h in 0...horzPics - 1 {
                images[v][h] = croppedImage(fullImage!, cropRect: CGRect(x: CGFloat(h) * imageSize * UIScreen.main.scale,y: CGFloat(v) * imageSize * UIScreen.main.scale,width: imageSize * UIScreen.main.scale,height: imageSize * UIScreen.main.scale))
                
            }
        }
        
        //Remove all views
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        for v in 0...vertPics - 1 {
            for h in 0...horzPics - 1 {
                let imgView = UIImageView(frame: CGRect(x: CGFloat(h) * imageSize, y: CGFloat(v) * imageSize , width: images[v][h].size.width / UIScreen.main.scale, height: images[v][h].size.height / UIScreen.main.scale))
                //Add all subviews
                self.view.addSubview(imgView)
                imgView.image = images[v][h]
                imgViews[v][h] = imgView
                imgView.alpha = 1.0
            }
        }
        
    }
    
    func croppedImage(_ image: UIImage, cropRect: CGRect) -> UIImage {
        let imageRef = image.cgImage!.cropping(to: cropRect)
        return UIImage(cgImage: imageRef!)
    }
    
    func rippleTransitionSetup(_ images: [[UIImageView]], h: Int, v: Int, iteration:Int){
        //Recursive flood and add numbers to tag
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
        
        rippleTransitionSetup(images, h: h - 1, v: v, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h + 1, v: v, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h, v: v - 1, iteration: iteration + 1)
        rippleTransitionSetup(images, h: h, v: v + 1, iteration: iteration + 1)
    }
    
    //Flood animations
    func rippleFade(_ image : UIImageView, delays : Double) {

        delay(delays) { () -> () in
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                image.alpha = 0.0
            })
        }
    }
    //Square flood animation
    func rippleFade2(_ image : UIImageView, delays : Double) {
        delay(delays) { () -> () in
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                image.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
                }, completion: { (finished) -> Void in
                    UIView.animate(withDuration: 0.8, animations: { () -> Void in
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

//
//  AppExploreMoreSlideViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/14/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class AppExploreMoreSlideViewController: UIViewController {

    var slideData: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var textLayersToAnimate = [CAShapeLayer]()
    var imageView = UIImageView()
    var textLabel = UILabel()
    var slideNumber = 0
    
    func createViewsWithLayouts(){
        if slideData != nil{
            
            imageView = UIImageView(image: UIImage(named: slideData!["image"].string!))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(imageView)
            imageView.backgroundColor = UIColor.lightGrayColor()
            imageView.contentMode = .ScaleAspectFit
            
            
            textLabel = UILabel()
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(textLabel)
            textLabel.text = slideData!["detailText"].string
            textLabel.font = UIFont(name: "Panton-Thin", size: 16)
            textLabel.textAlignment = .Left
            textLabel.minimumScaleFactor = 0.5
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.numberOfLines = 0
            textLabel.lineBreakMode = .ByWordWrapping
//            textLabel.layer.opacity = 0.0
            
            switch slideData!["style"].string! {
            case "oneOneImageDetailText":
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
                imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: 1.0, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Right, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10))
                
                
            break
            case "imageTextRatio":
                let ratio = CGFloat(Int(slideData!["ratio"].string!)!)
                
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: ratio / 100, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Right, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10))
                
                
                break
            default:
                print("style not found")
            }
            
            
            
            
            
            
        }
        
    }
    
    //ONLY CALL AFTER AUTOLAYOUT SETTLES
    func setupAnimatableLayers() {
        textLayersToAnimate = textLabel.strokeTextSimultaneously(width: 0.7, delay: 0, duration: 0.0, fade: false)
        textLabel.layer.opacity = 1.0
        if slideNumber != 0{
            textLayersToAnimate.forEach{ $0.strokeEnd = 0.0}
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

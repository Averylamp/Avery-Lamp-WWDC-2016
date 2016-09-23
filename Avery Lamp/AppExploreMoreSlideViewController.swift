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
            imageView.backgroundColor = UIColor.lightGray
            imageView.contentMode = .scaleAspectFit
            
            
            textLabel = UILabel()
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(textLabel)
            textLabel.text = slideData!["detailText"].string
            textLabel.font = UIFont(name: "Panton-Thin", size: 20)
            textLabel.textAlignment = .left
            textLabel.minimumScaleFactor = 0.5
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.numberOfLines = 0
            textLabel.lineBreakMode = .byWordWrapping
//            textLabel.layer.opacity = 0.0
            
            switch slideData!["style"].string! {
            case "oneOneImageDetailText":
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -10))
                imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -10))
                
                
            break
            case "imageTextRatio":
                let ratio = CGFloat(Int(slideData!["ratio"].string!)!)
                
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -10))
                self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: ratio / 100, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -10))
                
                
                break
            default:
                print("style not found")
            }
            
            
            
            
            
            
        }
        
    }
    
    //ONLY CALL AFTER AUTOLAYOUT SETTLES
    func setupAnimatableLayers() {
        textLayersToAnimate = textLabel.strokeTextSimultaneously(0.7, delay: 0, duration: 0.0, fade: false)
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

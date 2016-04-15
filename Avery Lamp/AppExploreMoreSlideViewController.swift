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
    
    
    
    func createViewsWithLayouts(){
        if slideData != nil{
            
            let image = UIImageView(image: UIImage(named: slideData!["image"].string!))
            image.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(image)
            image.backgroundColor = UIColor.lightGrayColor()
            image.contentMode = .ScaleAspectFit
            
            
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(text)
            text.text = slideData!["detailText"].string
            text.font = UIFont(name: "Panton-Regular", size: 16)
            text.textAlignment = .Center
            text.minimumScaleFactor = 0.5
            text.adjustsFontSizeToFitWidth = true
            text.numberOfLines = 0
            
            
            switch slideData!["style"].string! {
            case "oneOneImageDetailText":
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
                image.addConstraint(NSLayoutConstraint(item: image, attribute: .Width, relatedBy: .Equal, toItem: image, attribute: .Height, multiplier: 1.0, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Top, relatedBy: .Equal, toItem: image, attribute: .Bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Left, relatedBy: .Equal, toItem: image, attribute: .Left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Right, relatedBy: .Equal, toItem: image, attribute: .Right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10))
                
                
            break
            case "imageTextRatio":
                let ratio = CGFloat(Int(slideData!["ratio"].string!)!)
                
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10))
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10))
                self.view.addConstraint(NSLayoutConstraint(item: image, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: ratio / 100, constant: 0))
                
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Top, relatedBy: .Equal, toItem: image, attribute: .Bottom, multiplier: 1.0, constant: 5))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Left, relatedBy: .Equal, toItem: image, attribute: .Left, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Right, relatedBy: .Equal, toItem: image, attribute: .Right, multiplier: 1.0, constant: 0))
                self.view.addConstraint(NSLayoutConstraint(item: text, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10))
                
                
                break
            default:
                print("style not found")
            }
            
            
            
            
            
            
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

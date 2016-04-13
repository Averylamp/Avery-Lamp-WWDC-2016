//
//  ViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 1/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    var allLetters: [CAShapeLayer]? = nil
    var allLettersLayer: CALayer? = nil
    var singleStroke: [CAShapeLayer]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(self.view.frame.width, 80)))
        label.textAlignment = .Center
        self.view.addSubview(label)
        label.text = "Hello"
        label.font = UIFont(name: "Panton-Light", size: 80)
        singleStroke = label.strokeTextAnimated(width:2.5, delay: 0.0, duration: 5, fade: false)
        
        
        let secondLabel = UILabel(frame: CGRectMake(0,100,self.view.frame.width, 100))
        secondLabel.text = "My name is Avery"
        secondLabel.font = UIFont(name: "Panton-Regular", size: 30)
        allLettersLayer = secondLabel.layer
        self.view.addSubview(secondLabel)
        allLetters =  secondLabel.strokeTextSimultaneously(width: 0.5,delay: 0.0, duration: 4.0, fade: false)
        
        
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderForStrokeEnds(sender: AnyObject) {
        if allLetters != nil {
            allLetters?.forEach({ (shape :CAShapeLayer) in
                shape.strokeEnd = CGFloat((sender as! UISlider).value)
                if (sender as! UISlider).value == 1.0 {
                
                    UIView.animateWithDuration(3.0, animations: {
                        self.allLettersLayer?.opacity = 1.0
                    })
                    
                }else{
                    UIView.animateWithDuration(1.0, animations: { 
                        self.allLettersLayer?.opacity = 0.0
                    })
                    shape.fillColor = UIColor.clearColor().CGColor
                }
            })
        }
        if singleStroke != nil {
            singleStroke?.forEach{ $0.strokeEnd = CGFloat((sender as! UISlider).value)}
        }
    }

}


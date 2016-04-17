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
    var jsonData:JSON! = nil
    
    
    func setupJSON(){
        if let path = NSBundle.mainBundle().pathForResource("InfoData", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonData = JSON(data: data)
                if jsonData != JSON.null {
                    //                    print("jsonData:\(jsonData["Apps"])")
                } else {
                    print("could not get json")
                }
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("file not found")
        }
    }

    
    override func viewDidLoad() {
        setupJSON()
        
        
        let testInfoElement1 = InfoElement(frame: CGRectMake(30, 50, self.view.frame.width - 60, 100))
        self.view.addSubview(testInfoElement1)
        testInfoElement1.viewData = jsonData["InfoSections"][0]
        testInfoElement1.createLayout(left: true)
        let testInfoElement = InfoElement(frame: CGRectMake(30, 250, self.view.frame.width - 60, 100))
        testInfoElement.viewData = jsonData["InfoSections"][0]
        self.view.addSubview(testInfoElement)
        testInfoElement.createLayout(left: false)
        
        
        
        
//        super.viewDidLoad()
//        let label = UILabel(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(self.view.frame.width, 80)))
//        label.textAlignment = .Left
//        self.view.addSubview(label)
//        label.text = "Hello"
//        label.font = UIFont(name: "Panton-Light", size: 80)
//        singleStroke = label.strokeTextAnimated(width:2.5, delay: 0.0, duration: 5, fade: true)
//        
//        
//        let secondLabel = UILabel(frame: CGRectMake(0,100,self.view.frame.width, 100))
//        secondLabel.text = "My name is Avery"
//        secondLabel.font = UIFont(name: "Panton-Regular", size: 30)
//        allLettersLayer = secondLabel.layer
//        self.view.addSubview(secondLabel)
//        allLetters =  secondLabel.strokeTextSimultaneously(width: 0.5,delay: 0.0, duration: 4.0, fade: true)
//        
//        let thirdLabel = UILabel(frame: CGRectMake(20,200,self.view.frame.width - 40, 200))
//        thirdLabel.text = "Smith was created as a productivity tool for those that sit at desks.  The user sets specific actions, which can be triggered by knocking specific patterns into the desk that the phone rests on."
//        thirdLabel.numberOfLines = 0
//        thirdLabel.lineBreakMode = .ByWordWrapping
//        thirdLabel.font = UIFont(name: "Panton-Regular", size: 16)
////        thirdLabel.textAlignment = .Center
//        self.view.addSubview(thirdLabel)
//        allLettersLayer = thirdLabel.layer
//        allLetters = thirdLabel.strokeTextSimultaneously(width: 0.5, delay: 0.0, duration: 4.0, fade: false)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderForStrokeEnds(sender: AnyObject) {
//        if allLetters != nil {
//            allLetters?.forEach({ (shape :CAShapeLayer) in
//                shape.strokeEnd = CGFloat((sender as! UISlider).value)
//                if (sender as! UISlider).value == 1.0 {
//                
//                    UIView.animateWithDuration(3.0, animations: {
//                        self.allLettersLayer?.opacity = 1.0
//                    })
//                    
//                }else{
//                    UIView.animateWithDuration(1.0, animations: { 
//                        self.allLettersLayer?.opacity = 0.0
//                    })
//                    shape.fillColor = UIColor.clearColor().CGColor
//                }
//            })
//        }
//        if singleStroke != nil {
//            singleStroke?.forEach{ $0.strokeEnd = CGFloat((sender as! UISlider).value)}
//        }
    }

}


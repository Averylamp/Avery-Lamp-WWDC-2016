//
//  ViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
//import LTMorphingLabel

class ViewController: UIViewController {

    
    var allLetters: [CAShapeLayer]? = nil
    var allLettersLayer: CALayer? = nil
    var singleStroke: [CAShapeLayer]? = nil
    var jsonData:JSON! = nil
    
    
    func setupJSON(){
        if let path = Bundle.main.path(forResource: "InfoData", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
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
        
        
//        let testInfoElement1 = InfoElement(frame: CGRectMake(30, 50, self.view.frame.width - 60, 100))
//        self.view.addSubview(testInfoElement1)
//        testInfoElement1.viewData = jsonData["InfoSections"][0]
//        testInfoElement1.createLayout(left: true)
//        let testInfoElement = InfoElement(frame: CGRectMake(30, 250, self.view.frame.width - 60, 100))
//        testInfoElement.viewData = jsonData["InfoSections"][0]
//        self.view.addSubview(testInfoElement)
//        testInfoElement.createLayout(left: false)
//        
        
        
        
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
        
        let thirdLabel = LTMorphingLabel(frame: CGRect(x: 20,y: 200,width: self.view.frame.width - 40, height: 200))
        thirdLabel.text = "     Lorem ipsum dolor sit amet, ad sea populo pericula iracundia, mei ut convenire iudicabit. Cu audire vocibus liberavisse mel, tota sanctus ne pro. Probo tractatos laboramus an his. Usu ne brute mundi, invidunt eleifend reprimique ut usu.  \n     Wisi verterem mandamus eos te, ei vix natum elaboraret. Vim at docendi gloriatur accommodare, vel solum alienum eu. Consul iisque suavitate eum cu, cu eius impedit eam. Atqui doctus feugait mei cu, per quod inermis cu."
        thirdLabel.numberOfLines = 0
        thirdLabel.lineBreakMode = .byWordWrapping
        thirdLabel.font = UIFont(name: "Panton-Regular", size: 16)
//        thirdLabel.textAlignment = .Center
        self.view.addSubview(thirdLabel)
        allLettersLayer = thirdLabel.layer
        //allLetters = thirdLabel.strokeTextLetterByLetter(width: 0.6, delay: 0.0, duration: 10.0, characterStrokeDuration: 1.0, fade: true)
        delay(3.0) {
            thirdLabel.text = "asdfl asdlfkj asdjkfa;sldfalsdfa;lkfjaslfj9erhipqoenrvq[iner[igjqw erjqc[o qwoeifjqodfjqwp feiqwef"
            self.delay(3.0, closure: { 
                thirdLabel.text = " qowijpovqowef f qwef09q93q4 asdvnasdf wqe qwefjiqowef qw qwe qpowdef9-8hqg-98ert   "
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    @IBAction func sliderForStrokeEnds(_ sender: AnyObject) {
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


//
//  ViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 1/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(self.view.frame.width, 80)))
        label.textAlignment = .Center
        self.view.addSubview(label)
        label.text = "Hello"
        label.font = UIFont(name: "Panton-Light", size: 80)
        label.strokeTextAnimated(width:2.5, delay: 4.0, duration: 5, fade: true)
        
        
        let secondLabel = UILabel(frame: CGRectMake(0,100,self.view.frame.width, 100))
        secondLabel.text = "My name is Avery"
        secondLabel.font = UIFont(name: "Panton-Regular", size: 30)
        self.view.addSubview(secondLabel)
        secondLabel.strokeTextSimultaneously(width: 0.5,delay: 2.0, duration: 4.0, fade: true)
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


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
        let welcomeLabel  = UILabel(frame: CGRectMake(0,self.view.frame.height / 4 ,self.view.frame.width, 100))
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = UIFont(name: "Panton-Thin", size: 30)
        self.view.addSubview(welcomeLabel)
        welcomeLabel.drawOutlineAnimatedWithLineWidth(0.5, withDuration: 3, fadeToLabel: false)

        // Do any additional setup after loading the view.
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

//
//  ExpandedInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandedInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        delay(5.0) {
            print("DISMISSING VC")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

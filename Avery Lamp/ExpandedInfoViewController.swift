//
//  ExpandedInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandedInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var detailTextLabel:UILabel?
    var viewData:JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewData)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        detailTextLabel!.attributedText = getDetailText(section: 0)
        delay(2.0) {
            print("DISMISSING VC")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDetailText(section section:Int)->NSAttributedString{
        let flavorText = viewData!["ExtraInfoSlides"][section]["FlavorText"].string
        let subText = viewData!["ExtraInfoSlides"][section]["FlavorSubtext"].string
        let attributedString = NSMutableAttributedString(string: flavorText! + "\n" + subText!)
        let font = detailTextLabel?.font
        attributedString.addAttributes([NSFontAttributeName : font!], range: NSRangeFromString(flavorText!))
        let subtextFont = UIFont(name: font!.fontName, size: font!.pointSize - 4)
        attributedString.addAttributes([NSFontAttributeName : subtextFont!], range: NSMakeRange(flavorText!.characters.count + 1, subText!.characters.count))
        
        
        return attributedString
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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

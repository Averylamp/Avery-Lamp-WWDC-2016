//
//  ExpandedInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandedInfoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButton: UIButton!
    var infoElement: InfoElement?
    var detailTextLabel:UILabel?
    var viewData:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    var pages = [UIView]()
    var labelForSection = [UILabel]()
    
    override func viewDidAppear(animated: Bool) {
        detailTextLabel!.attributedText = getDetailText(section: 0)
        
        self.buttonLabel.addTarget(self, action: #selector(ExpandedInfoViewController.labelButtonClicked), forControlEvents: .TouchUpInside)
        
        self.buttonLabel.superview?.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - scrollView.frame.height)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * CGFloat(viewData!["ExtraInfoSlides"].count), self.scrollView.frame.height)
        pageControl.numberOfPages = viewData!["ExtraInfoSlides"].count
        
        //        print("view data \(viewData)")
        backButton.alpha = 0.0
        view.bringSubviewToFront(backButton)
        UIView.animateWithDuration(1.0) {
            self.backButton.alpha = 1.0
        }
        var lastPage:UIView?
        animationFired = Array(count: viewData!["ExtraInfoSlides"].count, repeatedValue: false)
        
        for index in 0..<viewData!["ExtraInfoSlides"].count {
            let page = UIView()
            page.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(page)
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0.0))
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0.0))
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            if index == 0 {
                self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0.0))
            }else{
                self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: lastPage, attribute: .Right, multiplier: 1.0, constant: 0.0))
            }
            lastPage = page
            pages.append(page)
            
            let textLabel = UILabel()
            labelForSection.append(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.numberOfLines = 0
            textLabel.lineBreakMode = .ByWordWrapping
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.7
            textLabel.textColor = UIColor.whiteColor()
            textLabel.text = viewData!["ExtraInfoSlides"][index]["DetailText"].string
            let font = UIFont(name: "Lato-Regular", size: 20)
            textLabel.font = font
            page.addSubview(textLabel)
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Width, relatedBy: .Equal, toItem: page, attribute: .Width, multiplier: 0.9, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Height, relatedBy: .Equal, toItem: page, attribute: .Height, multiplier: 0.9, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: page, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: page, attribute: .CenterY, multiplier: 0.95, constant: 0.0))
            textLabel.layer.opacity = 0.0
            page.layoutIfNeeded()
            if index == 0 {
                textLabel.strokeTextLetterByLetter(width: 0.6, delay: 0.0, duration: textAnimationDuration, characterStrokeDuration: textAnimationDuration / 3, fade: true, returnStuff: false)
                //                textLabel.strokeTextSimultaneously(width: 0.6, delay: 0.0, duration: textAnimationDuration, fade: true)
                animationFired[0]  = true
            }
            
        }
        
        
        
        
        //        delay(2.0) {
        //            print("DISMISSING VC")
        ////            self.dismissViewControllerAnimated(true, completion: nil)
        //        }
    }
    
    var textAnimationDuration = 1.5
    var animationFired = [Bool]()
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let fractionalPage = self.scrollView.contentOffset.x / scrollView.frame.width
        let page = Int(round(fractionalPage))
        if pageControl.currentPage != page {
            let imageFadeDuration = 0.8
            if viewData!["ExtraInfoSlides"][page]["DetailImage"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["DetailImage"].string{
                self.imageView.layer.removeAllAnimations()
                UIView.animateWithDuration(imageFadeDuration / 2, animations: {
                    print("Changing Images \(page) \(self.viewData!["ExtraInfoSlides"][page]["DetailImage"].string!)")
                    self.imageView.alpha = 0.0
                    }, completion: { (finished) in
                        self.imageView.image = UIImage(named: self.viewData!["ExtraInfoSlides"][page]["DetailImage"].string!)
                        UIView.animateWithDuration(imageFadeDuration / 2 , animations: {
                            
                            self.imageView.alpha = 1.0
                            }, completion: nil)
                })
            }
            if viewData!["ExtraInfoSlides"][page]["SectionSubtitle"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["SectionSubtitle"].string{
                self.infoElement?.sectionSubtitle.layer.removeAllAnimations()
                UIView.animateWithDuration(imageFadeDuration / 2, animations: {
                    self.infoElement?.sectionSubtitle.alpha = 0.0
                    }, completion: { (finished) in
                        self.infoElement?.sectionSubtitle.text = self.viewData!["ExtraInfoSlides"][page]["SectionSubtitle"].string
                        UIView.animateWithDuration(imageFadeDuration / 2 , animations: {
                            self.infoElement?.sectionSubtitle.alpha = 1.0
                            }, completion: nil)
                })
            }
            if viewData!["ExtraInfoSlides"][page]["FlavorText"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["FlavorText"].string || viewData!["ExtraInfoSlides"][page]["FlavorSubtext"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["FlavorSubtext"].string {
                self.detailTextLabel?.layer.removeAllAnimations()
                UIView.animateWithDuration(imageFadeDuration / 2, animations: {
                    self.detailTextLabel!.alpha = 0.0
                    }, completion: { (finished) in
                        self.detailTextLabel!.attributedText = self.getDetailText(section: page)
                        UIView.animateWithDuration(imageFadeDuration / 2 , animations: {
                            self.detailTextLabel!.alpha = 1.0
                            }, completion: nil)
                })
                
            }
            
            pageControl.currentPage = page
        }
        
        if animationFired[page] == false && labelForSection[page].layer.opacity == 0.0 {
            labelForSection[page].strokeTextLetterByLetter(width: 0.6, delay: 0.0, duration: textAnimationDuration, characterStrokeDuration: textAnimationDuration / 3, fade: true, fadeDuration: 0.4, returnStuff: false)
            //            labelForSection[page].strokeTextSimultaneously(width: 0.6, delay: 0.0, duration: textAnimationDuration, fade: true)
            animationFired[page] = true
        }
        
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        if viewData!["ExtraInfoSlides"][0]["DetailImage"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["DetailImage"].string{
            let imageFadeDuration = 0.3
            UIView.animateWithDuration(imageFadeDuration / 2, animations: {
                self.imageView.alpha = 0.0
                }, completion: { (finished) in
                    self.imageView.image = UIImage(named: self.viewData!["ExtraInfoSlides"][0]["DetailImage"].string!)
                    UIView.animateWithDuration(imageFadeDuration / 2 , animations: {
                        self.imageView.alpha = 1.0
                        }, completion: nil)
            })
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func labelButtonClicked(){
        self.buttonLabel.removeTarget(self, action: #selector(ExpandedInfoViewController.labelButtonClicked), forControlEvents: .TouchUpInside)
        self.backButtonClicked(NSObject())
        //        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

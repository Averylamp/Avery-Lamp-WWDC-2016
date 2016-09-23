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
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    var pages = [UIView]()
    var labelForSection = [UILabel]()
    
    override func viewDidAppear(_ animated: Bool) {
        detailTextLabel!.attributedText = getDetailText(0)
        
        self.buttonLabel.addTarget(self, action: #selector(ExpandedInfoViewController.labelButtonClicked), for: .touchUpInside)
        
        self.buttonLabel.superview?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - scrollView.frame.height)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(viewData!["ExtraInfoSlides"].count), height: self.scrollView.frame.height)
        pageControl.numberOfPages = viewData!["ExtraInfoSlides"].count
        
        backButton.alpha = 0.0
        view.bringSubview(toFront: backButton)
        UIView.animate(withDuration: 1.0, animations: {
            self.backButton.alpha = 1.0
        }) 
        var lastPage:UIView?
        animationFired = Array(repeating: false, count: viewData!["ExtraInfoSlides"].count)
        
        for index in 0..<viewData!["ExtraInfoSlides"].count {
            let page = UIView()
            page.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(page)
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0))
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0.0))
            self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .centerY, relatedBy: .equal, toItem: scrollView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            if index == 0 {
                self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0.0))
            }else{
                self.scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .left, relatedBy: .equal, toItem: lastPage, attribute: .right, multiplier: 1.0, constant: 0.0))
            }
            lastPage = page
            pages.append(page)
            
            let textLabel = UILabel()
            labelForSection.append(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.numberOfLines = 0
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.7
            textLabel.textColor = UIColor.white
            textLabel.text = viewData!["ExtraInfoSlides"][index]["DetailText"].string
            let font = UIFont(name: "Panton-Regular", size: 20)
            textLabel.font = font
            page.addSubview(textLabel)
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: page, attribute: .width, multiplier: 0.9, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: page, attribute: .height, multiplier: 0.9, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: page, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            page.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: page, attribute: .centerY, multiplier: 0.95, constant: 0.0))
            textLabel.layer.opacity = 0.0
            page.layoutIfNeeded()
            if index == 0 {
                textLabel.strokeTextLetterByLetter(0.6, delay: 0.0, duration: textAnimationDuration + 0.5, characterStrokeDuration: (textAnimationDuration + 0.5) / 3, fade: true, returnStuff: false)
                //                textLabel.strokeTextSimultaneously(width: 0.6, delay: 0.0, duration: textAnimationDuration, fade: true)
                animationFired[0]  = true
            }
            
        }
        
    }
    
    var textAnimationDuration = 1.2
    var animationFired = [Bool]()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fractionalPage = self.scrollView.contentOffset.x / scrollView.frame.width
        let page = Int(round(fractionalPage))
        if pageControl.currentPage != page {
            let imageFadeDuration = 0.8
            if viewData!["ExtraInfoSlides"][page]["DetailImage"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["DetailImage"].string{
                self.imageView.layer.removeAllAnimations()
                UIView.animate(withDuration: imageFadeDuration / 2, animations: {
                    self.imageView.alpha = 0.0
                    }, completion: { (finished) in
                        self.imageView.image = UIImage(named: self.viewData!["ExtraInfoSlides"][page]["DetailImage"].string!)
                        UIView.animate(withDuration: imageFadeDuration / 2 , animations: {
                            
                            self.imageView.alpha = 1.0
                            }, completion: nil)
                })
            }
            if viewData!["ExtraInfoSlides"][page]["SectionSubtitle"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["SectionSubtitle"].string{
                self.infoElement?.sectionSubtitle.layer.removeAllAnimations()
                UIView.animate(withDuration: imageFadeDuration / 2, animations: {
                    self.infoElement?.sectionSubtitle.alpha = 0.0
                    }, completion: { (finished) in
                        self.infoElement?.sectionSubtitle.text = self.viewData!["ExtraInfoSlides"][page]["SectionSubtitle"].string
                        UIView.animate(withDuration: imageFadeDuration / 2 , animations: {
                            self.infoElement?.sectionSubtitle.alpha = 1.0
                            }, completion: nil)
                })
            }
            if viewData!["ExtraInfoSlides"][page]["FlavorText"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["FlavorText"].string || viewData!["ExtraInfoSlides"][page]["FlavorSubtext"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["FlavorSubtext"].string {
                self.detailTextLabel?.layer.removeAllAnimations()
                UIView.animate(withDuration: imageFadeDuration / 2, animations: {
                    self.detailTextLabel!.alpha = 0.0
                    }, completion: { (finished) in
                        self.detailTextLabel!.attributedText = self.getDetailText(page)
                        UIView.animate(withDuration: imageFadeDuration / 2 , animations: {
                            self.detailTextLabel!.alpha = 1.0
                            }, completion: nil)
                })
                
            }
            
            pageControl.currentPage = page
        }
        
        if animationFired[page] == false && labelForSection[page].layer.opacity == 0.0 {
            labelForSection[page].strokeTextLetterByLetter(0.6, delay: 0.0, duration: textAnimationDuration, characterStrokeDuration: textAnimationDuration / 3, fade: true, fadeDuration: 0.4, returnStuff: false)
            //            labelForSection[page].strokeTextSimultaneously(width: 0.6, delay: 0.0, duration: textAnimationDuration, fade: true)
            animationFired[page] = true
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        if viewData!["ExtraInfoSlides"][0]["DetailImage"].string != viewData!["ExtraInfoSlides"][pageControl.currentPage]["DetailImage"].string{
            let imageFadeDuration = 0.3
            UIView.animate(withDuration: imageFadeDuration / 2, animations: {
                self.imageView.alpha = 0.0
                }, completion: { (finished) in
                    self.imageView.image = UIImage(named: self.viewData!["ExtraInfoSlides"][0]["DetailImage"].string!)
                    UIView.animate(withDuration: imageFadeDuration / 2 , animations: {
                        self.imageView.alpha = 1.0
                        }, completion: nil)
            })
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func labelButtonClicked(){
        self.buttonLabel.removeTarget(self, action: #selector(ExpandedInfoViewController.labelButtonClicked), for: .touchUpInside)
        self.backButtonClicked(NSObject())
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDetailText(_ section:Int)->NSAttributedString{
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

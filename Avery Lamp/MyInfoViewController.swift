//
//  MyInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class MyInfoViewController: UIViewController,UIScrollViewDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var jsonData:JSON! = nil
    
    var InfoElements = [InfoElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.463, green: 0.486, blue: 0.549, alpha: 1.00)
        setupJSON()
//        print(jsonData["InfoSections"].count)
        let numberOfPages = Int(ceil(Double(jsonData["InfoSections"].count) / 2.0))
        var numberOfSections = jsonData["InfoSections"].count
        pageControl.numberOfPages = numberOfPages
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(numberOfPages), scrollView.frame.height)
        scrollView.delegate = self
        
//        scrollView.layer.borderWidth = 2
//        scrollView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        var lastPage:UIView?
        for index in 0..<numberOfPages{
            let page = UIView()
            page.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(page)
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0))
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0))
            if index == 0{
                scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0))
            }else{
                scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: lastPage, attribute: .Right, multiplier: 1.0, constant: 0))
            }
            lastPage = page

            let widthRatio:CGFloat = 0.9
            
            let topSection = InfoElement()
            topSection.tag = index * 2 + 1000
            topSection.buttonLabel.tag = index * 2
            topSection.buttonLabel.addTarget(self, action: "expandInfoSectionClicked:", forControlEvents: .TouchUpInside)
            topSection.viewData = jsonData["InfoSections"][index * 2]
            topSection.translatesAutoresizingMaskIntoConstraints = false
            page.addSubview(topSection)
            
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .Top, relatedBy: .Equal, toItem: page, attribute: .Top, multiplier: 1.0, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .CenterX, relatedBy: .Equal, toItem: page, attribute: .CenterX, multiplier: 1.0, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .Width, relatedBy: .Equal, toItem: page, attribute: .Width, multiplier: widthRatio, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .Height, relatedBy: .Equal, toItem: page, attribute: .Height, multiplier: 0.48, constant: 0))
            
            InfoElements.append(topSection)
            numberOfSections -= 1
            
            if numberOfSections > 0{
                
                let bottomSection = InfoElement()
                bottomSection.viewData = jsonData["InfoSections"][index * 2 + 1]
                bottomSection.tag = index * 2 + 1 + 1000
                bottomSection.buttonLabel.tag = index * 2 + 1
                bottomSection.buttonLabel.addTarget(self, action: #selector(MyInfoViewController.expandInfoSectionClicked(_:)), forControlEvents: .TouchUpInside)
                bottomSection.translatesAutoresizingMaskIntoConstraints = false
                page.addSubview(bottomSection)
                
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .Top, relatedBy: .Equal, toItem: topSection, attribute: .Bottom, multiplier: 1.0, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .CenterX, relatedBy: .Equal, toItem: page, attribute: .CenterX, multiplier: 1.0, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .Width, relatedBy: .Equal, toItem: page, attribute: .Width, multiplier: widthRatio, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .Height, relatedBy: .Equal, toItem: page, attribute: .Height, multiplier: 0.48, constant: 0))
                InfoElements.append(bottomSection)
                
                numberOfSections -= 1
            }
            
        }
        
        InfoElements.forEach {
//            $0.layoutIfNeeded()
            if $0.tag % 2 == 0 {
                $0.createLayout(left: true)
            }else{
                $0.createLayout(left: false)
            }
        }
    }
    
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
    
    func expandInfoSectionClicked(button: UIButton){
        print("Expand Info Clicked")
        let clickedInfoElement = scrollView.viewWithTag(button.tag + 1000) as! InfoElement
        indexOfClickedElement = button.tag
        infoTransitionAnimator.infoSectionToExpand = clickedInfoElement
        self.performSegueWithIdentifier("expandedInfoSegue", sender: self)
    }
    var indexOfClickedElement:Int = 0
    
    let infoTransitionAnimator = InfoTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationController = segue.destinationViewController as? ExpandedInfoViewController {
            destinationController.transitioningDelegate = self
            destinationController.modalPresentationStyle = .Custom
            destinationController.viewData = jsonData["InfoSections"][indexOfClickedElement]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(pageControl.numberOfPages), scrollView.frame.height)
        
    }
    
    //MARK: -ScrollView Delegate Functions
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let fractionalPage = self.scrollView.contentOffset.x / scrollView.frame.width
        let page = Int(round(fractionalPage))
        pageControl.currentPage = page
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        infoTransitionAnimator.transitionMode = .Present
        return infoTransitionAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        infoTransitionAnimator.transitionMode = .Dismiss
        return infoTransitionAnimator
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

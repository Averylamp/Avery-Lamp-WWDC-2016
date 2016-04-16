//
//  AppExploreMoreViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/27/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class AppExploreMoreViewController: UIViewController, UIScrollViewDelegate {

    var exploreMoreInfo:JSON?
    
    @IBOutlet var themeLabels: [UILabel]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    var slideViewControllers = [AppExploreMoreSlideViewController]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if exploreMoreInfo != nil{
            scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(exploreMoreInfo!["expandedDetails"].count), scrollView.frame.height)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.scrollEnabled = false
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.scrollView.addGestureRecognizer(swipeRecognizer)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.scrollView.addGestureRecognizer(swipeRecognizer)

//        print("More Info Data \(exploreMoreInfo)")
        
        // Do any additional setup after loading the view.
    }
    
    func handleSwipe(gesture:UISwipeGestureRecognizer){
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        var indexOfDestination = currentPage
        print("Current Page \(currentPage)")
        let scrollDuration = 0.8
        var animationFired = false
        
        if(gesture.direction == UISwipeGestureRecognizerDirection.Left){
            print("Right")
            if currentPage < slideViewControllers.count - 1{
                indexOfDestination += 1
                animationFired = true
                UIView.animateWithDuration(scrollDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                        self.scrollView.setContentOffset(CGPointMake((CGFloat(currentPage) + 1.0) * self.scrollView.frame.width, self.scrollView.contentOffset.y), animated: false)
                    }, completion: nil)
            }
    }
        if(gesture.direction == UISwipeGestureRecognizerDirection.Right){
            print("Left")
            if currentPage > 0{
                animationFired = true
                indexOfDestination -= 1
                UIView.animateWithDuration(scrollDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                    self.scrollView.setContentOffset(CGPointMake((CGFloat(currentPage) - 1.0) * self.scrollView.frame.width, self.scrollView.contentOffset.y), animated: false)
                    }, completion: nil)
            }
        }
        if animationFired{
            let letterDrawDuration = scrollDuration * 3.0
            slideViewControllers[indexOfDestination].textLabel.layer.opacity = 0.0
            slideViewControllers[indexOfDestination].textLayersToAnimate.forEach{ $0.strokeEnd = 0.0}
            CATransaction.begin()
            CATransaction.setAnimationDuration(scrollDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            let currentSlideGlyphs = self.slideViewControllers[currentPage].textLayersToAnimate
            currentSlideGlyphs.forEach{ $0.strokeEnd = 0.0 }
            UIView.animateWithDuration(scrollDuration / 10) {
                self.slideViewControllers[currentPage].textLabel.layer.opacity = 0.0
            }
            CATransaction.commit()
            delay(scrollDuration / 10) {
                CATransaction.begin()
                CATransaction.setAnimationDuration(letterDrawDuration)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                let destinationSlideGlyphs = self.slideViewControllers[indexOfDestination].textLayersToAnimate
                destinationSlideGlyphs.forEach{ $0.strokeEnd = 1.0 }
                UIView.animateWithDuration(scrollDuration / 5, delay: letterDrawDuration, options: .CurveEaseInOut, animations: {
                    self.slideViewControllers[indexOfDestination].textLabel.layer.opacity = 1.0
                    }, completion: nil)
                CATransaction.commit()
            }
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        slideViewControllers.forEach{ $0.setupAnimatableLayers() }
        //        print("More Info Data TAKE 2 \(exploreMoreInfo)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moreInfoLinkClicked(sender: AnyObject) {
        if let urlString = exploreMoreInfo!["extraInfoLink"].string {
            var url = NSURL(string: urlString)!
            if UIApplication.sharedApplication().canOpenURL(url)  {
                UIApplication.sharedApplication().openURL(url)
            } else {
                if var index = urlString.rangeOfString("://watch?v=", options: .BackwardsSearch)?.startIndex {
                    index = index.advancedBy(11)
                    url = NSURL(string: "https://youtu.be/\(urlString.substringFromIndex(index))")!
                }
                UIApplication.sharedApplication().openURL(url)
            }
        }
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

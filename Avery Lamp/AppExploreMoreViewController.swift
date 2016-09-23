//
//  AppExploreMoreViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/6/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class AppExploreMoreViewController: UIViewController {

    var exploreMoreInfo:JSON?
    
    @IBOutlet var themeLabels: [UILabel]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slideViewControllers = [AppExploreMoreSlideViewController]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if exploreMoreInfo != nil{
            scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(exploreMoreInfo!["expandedDetails"].count), height: scrollView.frame.height)
            pageControl.numberOfPages = exploreMoreInfo!["expandedDetails"].count
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.scrollView.addGestureRecognizer(swipeRecognizer)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.scrollView.addGestureRecognizer(swipeRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func handleSwipe(_ gesture:UISwipeGestureRecognizer){
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        var indexOfDestination = currentPage
        let scrollDuration = 0.4
        var animationFired = false
        
        if(gesture.direction == UISwipeGestureRecognizerDirection.left){
            if currentPage < slideViewControllers.count - 1{
                indexOfDestination += 1
                animationFired = true
                UIView.animate(withDuration: scrollDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                        self.scrollView.setContentOffset(CGPoint(x: (CGFloat(currentPage) + 1.0) * self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: false)
                    }, completion: nil)
            }
    }
        if(gesture.direction == UISwipeGestureRecognizerDirection.right){
            if currentPage > 0{
                animationFired = true
                indexOfDestination -= 1
                UIView.animate(withDuration: scrollDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                    self.scrollView.setContentOffset(CGPoint(x: (CGFloat(currentPage) - 1.0) * self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: false)
                    }, completion: nil)
            }
        }
        if animationFired{
            pageControl.currentPage = indexOfDestination
            let letterDrawDuration = scrollDuration * 3.0
            slideViewControllers[indexOfDestination].textLabel.layer.opacity = 0.0
            slideViewControllers[indexOfDestination].textLayersToAnimate.forEach{ $0.strokeEnd = 0.0}
            CATransaction.begin()
            CATransaction.setAnimationDuration(scrollDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            let currentSlideGlyphs = self.slideViewControllers[currentPage].textLayersToAnimate
            currentSlideGlyphs.forEach{ $0.strokeEnd = 0.0 }
            UIView.animate(withDuration: scrollDuration / 10, animations: {
                self.slideViewControllers[currentPage].textLabel.layer.opacity = 0.0
            }) 
            CATransaction.commit()
            delay(scrollDuration / 10) {
                CATransaction.begin()
                CATransaction.setAnimationDuration(letterDrawDuration)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                let destinationSlideGlyphs = self.slideViewControllers[indexOfDestination].textLayersToAnimate
                destinationSlideGlyphs.forEach{ $0.strokeEnd = 1.0 }
                UIView.animate(withDuration: scrollDuration / 5, delay: letterDrawDuration, options: UIViewAnimationOptions(), animations: {
                    self.slideViewControllers[indexOfDestination].textLabel.layer.opacity = 1.0
                    }, completion: nil)
                CATransaction.commit()
            }
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let dTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: dTime , execute: closure)
//        (DispatchQueue.main).asyncAfter(
//            deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now()) + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        slideViewControllers.forEach{ $0.setupAnimatableLayers() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreInfoLinkClicked(_ sender: AnyObject) {
        if let urlString = exploreMoreInfo!["extraInfoLink"].string {
            var url = URL(string: urlString)!
            if UIApplication.shared.canOpenURL(url)  {
                UIApplication.shared.openURL(url)
            } else {
                if var index = urlString.range(of: "://watch?v=", options: .backwards)?.lowerBound {
                    //FIX THIS LINE, possibly broken with Swift 3 update
                    urlString.index(index, offsetBy: 11)
//                    index = urlString.index(index, offsetBy: 11)
                    url = URL(string: "https://youtu.be/\(urlString.substring(from: index))")!
                }
                UIApplication.shared.openURL(url)
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

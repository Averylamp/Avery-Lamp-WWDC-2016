//
//  InfoTransition.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
import LTMorphingLabel

class InfoTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum InfoTransitionMode:Int{
        case Present, Dismiss
    }
    
    var duration = 0.7
    
    var transitionMode: InfoTransitionMode = .Present
    
    var allDissappearingViews = [UIView]()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    var infoSectionToExpand: InfoElement?
    var animationInfoSection: InfoElement! = nil
    var backgroundImageConstraintsToReturnTo: [NSLayoutConstraint]?
    var buttonLabelConstraintsToReturnTo: [NSLayoutConstraint]?
    var animationInfoSectionConstraintsToReturnTo: [NSLayoutConstraint]?
    var infoSectionFrameToReturnTo: CGRect?
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let originalView = transitionContext.containerView()
        
        if transitionMode == .Present && infoSectionToExpand != nil {//MARK: Presenting animations
            let initialVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.childViewControllers.last as? MyInfoViewController
            let centerOfInfoSection = infoSectionToExpand?.superview!.convertPoint(infoSectionToExpand!.center, toView: originalView)
            print("Center found \(centerOfInfoSection)")
            
            allDissappearingViews = [UIView]()
            allDissappearingViews.appendContentsOf(initialVC!.view.subviews)
            
            print("Dissappearing Views count \(originalView?.subviews.count)")
          
            
            let presentingViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ExpandedInfoViewController
            let presentingView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            presentingView.backgroundColor = originalView?.backgroundColor
            originalView?.addSubview(presentingView)
            
            animationInfoSection = InfoElement(frame: infoSectionToExpand!.frame)
            animationInfoSection.viewData = infoSectionToExpand?.viewData
            animationInfoSection.center = centerOfInfoSection!
            presentingView.addSubview(animationInfoSection)
            animationInfoSection.createLayout(left: infoSectionToExpand!.sideLeft)
            infoSectionToExpand?.alpha = 0.0
            
            
            animationInfoSection.backgroundImage.layoutIfNeeded()
            animationInfoSection.buttonLabel.layoutIfNeeded()
            backgroundImageConstraintsToReturnTo = animationInfoSection.backgroundImage.constraints
            buttonLabelConstraintsToReturnTo = animationInfoSection.buttonLabel.constraints
            infoSectionFrameToReturnTo = animationInfoSection.frame

            
            presentingViewController?.buttonLabel = animationInfoSection.buttonLabel
            presentingViewController?.imageView = animationInfoSection.backgroundImage
            
            let detailInfoView = UIView()
            animationInfoSection.detailInfoView = detailInfoView
            detailInfoView.backgroundColor = UIColor.whiteColor()
            detailInfoView.translatesAutoresizingMaskIntoConstraints = false
            animationInfoSection.addSubview(detailInfoView)
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .Height, relatedBy: .Equal, toItem: animationInfoSection.buttonLabel, attribute: .Height, multiplier: 1.0, constant: 0))
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .Left, relatedBy: .Equal, toItem: animationInfoSection.buttonLabel, attribute: .Right, multiplier: 1.0, constant: 0.0))
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .CenterY, relatedBy: .Equal, toItem: animationInfoSection.buttonLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            let widthConstraint = NSLayoutConstraint(item: detailInfoView, attribute: .Width, relatedBy: .Equal, toItem: animationInfoSection.buttonLabel, attribute:.Width , multiplier: 0.0, constant: 0.0)
            animationInfoSection.addConstraint(widthConstraint)
            detailInfoView.layoutIfNeeded()
       
            animationInfoSectionConstraintsToReturnTo = animationInfoSection.constraints
            
            let detailInfoLabel = UILabel()
            animationInfoSection.detailInfoLabel = detailInfoLabel
            presentingViewController?.detailTextLabel = detailInfoLabel
            presentingViewController?.infoElement = animationInfoSection
            detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            detailInfoView.addSubview(detailInfoLabel)
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .Width, relatedBy: .Equal, toItem: detailInfoView, attribute: .Width, multiplier: 0.9, constant: 0.0))
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .Height, relatedBy: .Equal, toItem: detailInfoView, attribute: .Height, multiplier: 0.9, constant: 0.0))
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .CenterX, relatedBy: .Equal, toItem: detailInfoView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            let yDisplacementConstraint =  NSLayoutConstraint(item: detailInfoLabel, attribute: .CenterY, relatedBy: .Equal, toItem: detailInfoView, attribute: .CenterY, multiplier: 1.0, constant: 20.0)
            detailInfoLabel.alpha = 0.0
            detailInfoLabel.numberOfLines = 0
            detailInfoLabel.lineBreakMode = .ByWordWrapping
            detailInfoLabel.textAlignment = .Center
            detailInfoLabel.font = UIFont(name: "Lato-Regular", size: 18)
            detailInfoLabel.text = "Class of 2020"
            detailInfoView.addConstraint(yDisplacementConstraint)
            
            presentingViewController?.scrollView.alpha = 0.0
            
            UIView.animateWithDuration(duration, animations: {
                presentingViewController?.scrollView.alpha = 1.0
                self.animationInfoSection.buttonLabel.layer.shadowOpacity = 0.0
                
                
                let backgroundImage = self.animationInfoSection.backgroundImage
                let buttonLabel = self.animationInfoSection.buttonLabel
                self.animationInfoSection.removeConstraints(self.animationInfoSection.constraints)
                
                //NEEDS TO PROBABLY BE CHANGED
                self.animationInfoSection.frame = presentingView.frame
                
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Width, relatedBy: .Equal, toItem: presentingView, attribute: .Width, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Top, relatedBy: .Equal, toItem: presentingView, attribute: .Top, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .CenterX, relatedBy: .Equal, toItem: presentingView, attribute: .CenterX, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Height, relatedBy: .Equal, toItem: presentingView, attribute: .Height, multiplier: 0.35, constant: 0))
                
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: presentingView, attribute: .Width, multiplier: 0.5, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Left, relatedBy: .Equal, toItem: presentingView, attribute: .Left, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Top, relatedBy: .Equal, toItem: backgroundImage, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 1.0, constant: 0.0))
                
                
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .Left, relatedBy: .Equal, toItem: buttonLabel, attribute: .Right, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .CenterY, relatedBy: .Equal, toItem: buttonLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .Width, relatedBy: .Equal, toItem: presentingView, attribute: .Width, multiplier: 0.5, constant: 0.0))
                
                presentingView.layoutIfNeeded()
                
                
                
                }, completion: { (finished) in
                    transitionContext.completeTransition(true)
            } )
            
            UIView.animateWithDuration(0.3, delay: duration, options: .CurveEaseInOut, animations: { 
                detailInfoView.removeConstraint(yDisplacementConstraint)
                detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .CenterY, relatedBy: .Equal, toItem: detailInfoView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
                detailInfoLabel.alpha = 1.0
                detailInfoView.layoutIfNeeded()
                }, completion: nil)
            
            
            allDissappearingViews.forEach({ (view) in
                UIView.animateWithDuration(duration / 2, animations: {
                    view.center = CGPointMake(view.center.x, view.center.y  - 20)
                    view.alpha = 0.0
                })
            })
            
            
            
        }else  { //MARK: Dismissing animations
            allDissappearingViews.forEach({ (view) in
                UIView.animateWithDuration(duration / 2, animations: {
                    view.center = CGPointMake(view.center.x, view.center.y  + 20)
                    view.alpha = 1.0
                })
            })
            let presentingViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ExpandedInfoViewController
            let presentingView = transitionContext.viewForKey(UITransitionContextFromViewKey)!

            
            UIView.animateWithDuration(duration / 3, animations: {
                presentingViewController?.pageControl.alpha = 0.0
                presentingViewController?.scrollView.alpha = 0.0
                presentingViewController?.backButton.alpha = 0.0
                }, completion: nil)
            
            self.animationInfoSection.layoutIfNeeded()
            print("presenting view cons - \(presentingView.constraints.count)\nanimationv cons - \(self.animationInfoSection.constraints.count)\nto replace anv view cons - \(animationInfoSectionConstraintsToReturnTo?.count), button -  \(buttonLabelConstraintsToReturnTo?.count), image - \(backgroundImageConstraintsToReturnTo?.count)")
            UIView.animateWithDuration(duration, animations: {
                self.animationInfoSection.frame = self.infoSectionFrameToReturnTo!
                presentingView.removeConstraints(presentingView.constraints)
//                self.animationInfoSection.removeConstraints(self.animationInfoSection.constraints)
                self.animationInfoSection.addConstraints(self.animationInfoSectionConstraintsToReturnTo!)
                self.animationInfoSection.layoutIfNeeded()
                presentingView.layoutIfNeeded()
                
                }, completion: { (finished) in
                    presentingView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                    self.infoSectionToExpand?.alpha = 1.0
            })

            
        }
    }
    
}

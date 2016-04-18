//
//  InfoTransition.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class InfoTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum InfoTransitionMode:Int{
        case Present, Dismiss
    }
    
    var duration = 0.5
    
    var transitionMode: InfoTransitionMode = .Present
    
    var allDissappearingViews = [UIView]()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    var infoSectionToExpand: InfoElement?
    var backgroundImageConstraintsToReturnTo: [NSLayoutConstraint]?
    var buttonLabelConstraintsToReturnTo: [NSLayoutConstraint]?
    var animationInfoSectionConstraintsToReturnTo: [NSLayoutConstraint]?
    var infoSectionFrameToReturnTo: CGRect?
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let originalView = transitionContext.containerView()
        
        if transitionMode == .Present && infoSectionToExpand != nil {
            let initialVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.childViewControllers.first as? MyInfoViewController
            let centerOfInfoSection = infoSectionToExpand?.superview!.convertPoint(infoSectionToExpand!.center, toView: originalView)
            print("Center found \(centerOfInfoSection)")
            
            allDissappearingViews = [UIView]()
            allDissappearingViews.appendContentsOf(initialVC!.view.subviews)
            
            print("Dissappearing Views count \(originalView?.subviews.count)")
          
            
            let presentingViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ExpandedInfoViewController
            let presentingView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            originalView?.addSubview(presentingView)
            
            let animationInfoSection = InfoElement(frame: infoSectionToExpand!.frame)
            animationInfoSection.viewData = infoSectionToExpand?.viewData
            animationInfoSection.center = centerOfInfoSection!
            presentingView.addSubview(animationInfoSection)
            animationInfoSection.createLayout(left: infoSectionToExpand!.sideLeft)
            infoSectionToExpand?.alpha = 0.0
            
            animationInfoSection.backgroundImage.layoutIfNeeded()
            backgroundImageConstraintsToReturnTo = animationInfoSection.backgroundImage.constraints
            buttonLabelConstraintsToReturnTo = animationInfoSection.buttonLabel.constraints
            animationInfoSectionConstraintsToReturnTo = animationInfoSection.constraints
            infoSectionFrameToReturnTo = animationInfoSection.frame
            UIView.animateWithDuration(duration, animations: {
                let backgroundImage = animationInfoSection.backgroundImage
                let buttonLabel = animationInfoSection.buttonLabel

                print("view subconstraints count - \(animationInfoSection.constraints.count)")
                animationInfoSection.removeConstraints(animationInfoSection.constraints)
                
                
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Width, relatedBy: .Equal, toItem: presentingView, attribute: .Width, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Top, relatedBy: .Equal, toItem: presentingView, attribute: .Top, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .CenterX, relatedBy: .Equal, toItem: presentingView, attribute: .CenterX, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Height, relatedBy: .Equal, toItem: presentingView, attribute: .Height, multiplier: 0.35, constant: 0))
                
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: presentingView, attribute: .Width, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .CenterX, relatedBy: .Equal, toItem: presentingView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Top, relatedBy: .Equal, toItem: backgroundImage, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
//                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 1.0, constant: 0.0))
                
                
                presentingView.layoutIfNeeded()
                
                
                
                }, completion: nil)
            //            animationInfoSection.buttonLabel.removeConstraints(animationInfoSection)
            
            allDissappearingViews.forEach({ (view) in
                UIView.animateWithDuration(duration / 2, animations: {
                    view.center = CGPointMake(view.center.x, view.center.y  - 20)
                    view.alpha = 0.0
                })
            })
            
            
            //            animationInfoSection.removeConstraints(animationInfoSection.constraints)
            transitionContext.completeTransition(true)
            
        }else  {
            allDissappearingViews.forEach({ (view) in
                UIView.animateWithDuration(duration / 2, animations: {
                    view.center = CGPointMake(view.center.x, view.center.y  + 20)
                    view.alpha = 1.0
                })
            })
            infoSectionToExpand?.alpha = 1.0
            transitionContext.completeTransition(true)
        }
    }
    
}

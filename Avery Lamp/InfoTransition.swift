//
//  InfoTransition.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/17/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
//import LTMorphingLabel

class InfoTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum InfoTransitionMode:Int{
        case present, dismiss
    }
    
    var duration = 0.7
    
    var transitionMode: InfoTransitionMode = .present
    
    var allDissappearingViews = [UIView]()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    var infoSectionToExpand: InfoElement?
    var animationInfoSection: InfoElement! = nil
    var backgroundImageConstraintsToReturnTo: [NSLayoutConstraint]?
    var buttonLabelConstraintsToReturnTo: [NSLayoutConstraint]?
    var animationInfoSectionConstraintsToReturnTo: [NSLayoutConstraint]?
    var infoSectionFrameToReturnTo: CGRect?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let originalView = transitionContext.containerView
        
        if transitionMode == .present && infoSectionToExpand != nil {//MARK: Presenting animations
            let initialVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.childViewControllers.last as? MyInfoViewController
            let centerOfInfoSection = infoSectionToExpand?.superview!.convert(infoSectionToExpand!.center, to: originalView)
            
            allDissappearingViews = [UIView]()
            allDissappearingViews.append(contentsOf: initialVC!.view.subviews)
            
            let presentingViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ExpandedInfoViewController
            let presentingView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            presentingView.backgroundColor = originalView.backgroundColor
            originalView.addSubview(presentingView)
            
            animationInfoSection = InfoElement(frame: infoSectionToExpand!.frame)
            animationInfoSection.viewData = infoSectionToExpand?.viewData
            animationInfoSection.center = centerOfInfoSection!
            presentingView.addSubview(animationInfoSection)
            animationInfoSection.createLayout(infoSectionToExpand!.sideLeft)
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
            detailInfoView.backgroundColor = UIColor.white
            detailInfoView.translatesAutoresizingMaskIntoConstraints = false
            animationInfoSection.addSubview(detailInfoView)
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .height, relatedBy: .equal, toItem: animationInfoSection.buttonLabel, attribute: .height, multiplier: 1.0, constant: 0))
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .left, relatedBy: .equal, toItem: animationInfoSection.buttonLabel, attribute: .right, multiplier: 1.0, constant: 0.0))
            animationInfoSection.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .centerY, relatedBy: .equal, toItem: animationInfoSection.buttonLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            let widthConstraint = NSLayoutConstraint(item: detailInfoView, attribute: .width, relatedBy: .equal, toItem: animationInfoSection.buttonLabel, attribute:.width , multiplier: 0.0, constant: 0.0)
            animationInfoSection.addConstraint(widthConstraint)
            detailInfoView.layoutIfNeeded()
       
            animationInfoSectionConstraintsToReturnTo = animationInfoSection.constraints
            
            let detailInfoLabel = UILabel()
            animationInfoSection.detailInfoLabel = detailInfoLabel
            presentingViewController?.detailTextLabel = detailInfoLabel
            presentingViewController?.infoElement = animationInfoSection
            detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            detailInfoView.addSubview(detailInfoLabel)
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .width, relatedBy: .equal, toItem: detailInfoView, attribute: .width, multiplier: 0.9, constant: 0.0))
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .height, relatedBy: .equal, toItem: detailInfoView, attribute: .height, multiplier: 0.9, constant: 0.0))
            detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .centerX, relatedBy: .equal, toItem: detailInfoView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            let yDisplacementConstraint =  NSLayoutConstraint(item: detailInfoLabel, attribute: .centerY, relatedBy: .equal, toItem: detailInfoView, attribute: .centerY, multiplier: 1.0, constant: 20.0)
            detailInfoLabel.alpha = 0.0
            detailInfoLabel.numberOfLines = 0
            detailInfoLabel.lineBreakMode = .byWordWrapping
            detailInfoLabel.textAlignment = .center
            detailInfoLabel.font = UIFont(name: "Lato-Regular", size: 18)
            detailInfoLabel.text = "Class of 2020"
            detailInfoView.addConstraint(yDisplacementConstraint)
            
            presentingViewController?.scrollView.alpha = 0.0
            
            UIView.animate(withDuration: duration, animations: {
                presentingViewController?.scrollView.alpha = 1.0
                self.animationInfoSection.buttonLabel.layer.shadowOpacity = 0.0
                
                
                let backgroundImage = self.animationInfoSection.backgroundImage
                let buttonLabel = self.animationInfoSection.buttonLabel
                self.animationInfoSection.removeConstraints(self.animationInfoSection.constraints)
                
                //NEEDS TO PROBABLY BE CHANGED
                self.animationInfoSection.frame = presentingView.frame
                
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .width, relatedBy: .equal, toItem: presentingView, attribute: .width, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: presentingView, attribute: .top, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: presentingView, attribute: .centerX, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .height, relatedBy: .equal, toItem: presentingView, attribute: .height, multiplier: 0.35, constant: 0))
                
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .width, relatedBy: .equal, toItem: presentingView, attribute: .width, multiplier: 0.5, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .left, relatedBy: .equal, toItem: presentingView, attribute: .left, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .top, relatedBy: .equal, toItem: backgroundImage, attribute: .bottom, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .width, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 1.0, constant: 0.0))
                
                
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .height, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 1.0, constant: 0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .left, relatedBy: .equal, toItem: buttonLabel, attribute: .right, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .centerY, relatedBy: .equal, toItem: buttonLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                presentingView.addConstraint(NSLayoutConstraint(item: detailInfoView, attribute: .width, relatedBy: .equal, toItem: presentingView, attribute: .width, multiplier: 0.5, constant: 0.0))
                
                presentingView.layoutIfNeeded()
                
                
                
                }, completion: { (finished) in
                    transitionContext.completeTransition(true)
            } )
            
            UIView.animate(withDuration: 0.3, delay: duration, options: UIViewAnimationOptions(), animations: { 
                detailInfoView.removeConstraint(yDisplacementConstraint)
                detailInfoView.addConstraint(NSLayoutConstraint(item: detailInfoLabel, attribute: .centerY, relatedBy: .equal, toItem: detailInfoView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                detailInfoLabel.alpha = 1.0
                detailInfoView.layoutIfNeeded()
                }, completion: nil)
            
            
            allDissappearingViews.forEach({ (view) in
                UIView.animate(withDuration: duration / 2, animations: {
                    view.center = CGPoint(x: view.center.x, y: view.center.y  - 20)
                    view.alpha = 0.0
                })
            })
            
            
            
        }else  { //MARK: Dismissing animations
            allDissappearingViews.forEach({ (view) in
                UIView.animate(withDuration: duration / 2, animations: {
                    view.center = CGPoint(x: view.center.x, y: view.center.y  + 20)
                    view.alpha = 1.0
                })
            })
            let presentingViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? ExpandedInfoViewController
            let presentingView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

            
            UIView.animate(withDuration: duration / 3, animations: {
                presentingViewController?.pageControl.alpha = 0.0
                presentingViewController?.scrollView.alpha = 0.0
                presentingViewController?.backButton.alpha = 0.0
                }, completion: nil)
            
            self.animationInfoSection.layoutIfNeeded()
//            print("presenting view cons - \(presentingView.constraints.count)\nanimationv cons - \(self.animationInfoSection.constraints.count)\nto replace anv view cons - \(animationInfoSectionConstraintsToReturnTo?.count), button -  \(buttonLabelConstraintsToReturnTo?.count), image - \(backgroundImageConstraintsToReturnTo?.count)")
            UIView.animate(withDuration: duration, animations: {
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

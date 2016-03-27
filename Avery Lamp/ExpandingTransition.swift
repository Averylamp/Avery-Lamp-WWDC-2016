//
//  ExpandingTransition.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/27/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum ExpandingTransitionMode: Int {
        case Present, Dismiss
    }

    
    var startPoint = CGPointZero {
        didSet{
            if let buttonObject = expandingObject {
                buttonObject.center = startPoint
            }
        }
    }
    
    var duration = 0.5
    
    var transitionMode: ExpandingTransitionMode = .Present
    
    var expandingObject: UIView?
    var transitionColor: UIColor = .whiteColor()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let originalView = transitionContext.containerView()
        
        if transitionMode == .Present {
            let presentingViewController = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentingViewController.center
            let originalSize = presentingViewController.frame.size
            
            let maxX = max(originalCenter.x, originalSize.width -  originalCenter.x)
            let maxY = max(originalCenter.y, originalSize.height -  originalCenter.y)
            let farthestCorner = sqrt(maxX * maxX + maxY * maxY) * 2
            
            expandingObject = UIView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(farthestCorner, farthestCorner)))
            expandingObject?.layer.cornerRadius = expandingObject!.frame.size.height / 2
            expandingObject?.center = startPoint
            expandingObject?.transform = CGAffineTransformMakeScale(0.001, 0.001)
            expandingObject?.backgroundColor = transitionColor
            originalView!.addSubview(expandingObject!)
            
            presentingViewController.center = startPoint
            presentingViewController.transform = CGAffineTransformMakeScale(0.001, 0.001)
            presentingViewController.alpha = 0
            originalView?.addSubview(presentingViewController)
            UIView.animateWithDuration(duration, animations: { 
                self.expandingObject?.transform = CGAffineTransformIdentity
                presentingViewController.transform = CGAffineTransformIdentity
//                presentingViewController.alpha = 1.0
                presentingViewController.center = originalCenter
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
            
        }else{
            let disappearingViewController = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let originalCenter = disappearingViewController.center
            let originalSize = disappearingViewController.frame.size
            
            
            if let expandingObject = expandingObject {
                
                let maxX = max(originalCenter.x, originalSize.width -  originalCenter.x)
                let maxY = max(originalCenter.y, originalSize.height -  originalCenter.y)
                let farthestCorner = sqrt(maxX * maxX + maxY * maxY) * 2

                expandingObject.frame = CGRect(origin: CGPointZero, size: CGSizeMake(farthestCorner, farthestCorner))
                expandingObject.center = self.startPoint
                expandingObject.layer.cornerRadius = expandingObject.frame.size.height / 2
            }
            
            UIView.animateWithDuration(duration, animations: { 
                self.expandingObject?.transform = CGAffineTransformMakeScale(0.001, 0.001)
                disappearingViewController.transform = CGAffineTransformMakeScale(0.001, 0.001)
                disappearingViewController.center = self.startPoint
                disappearingViewController.alpha = 0.0
                
                }, completion: { (_) in
                    disappearingViewController.removeFromSuperview()
                    self.expandingObject?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        }
    }
    
}

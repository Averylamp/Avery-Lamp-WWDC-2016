//
//  ExpandingTransition.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/7/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum ExpandingTransitionMode: Int {
        case present, dismiss
    }

    
    var startPoint = CGPoint.zero {
        didSet{
            if let buttonObject = expandingObject {
                buttonObject.center = startPoint
            }
        }
    }
    
    var duration = 0.5
    
    var transitionMode: ExpandingTransitionMode = .present
    
    var expandingObject: UIView?
    var transitionColor: UIColor = UIColor.white
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let originalView = transitionContext.containerView
        
        if transitionMode == .present {
            let presentingView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let originalCenter = presentingView.center
            let originalSize = presentingView.frame.size
            
            let maxX = max(startPoint.x, originalSize.width -  startPoint.x)
            let maxY = max(startPoint.y, originalSize.height -  startPoint.y)
            let fullHeight = sqrt(maxX * maxX + maxY * maxY) * 2
            
            expandingObject = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: fullHeight, height: fullHeight)))
            expandingObject?.layer.cornerRadius = expandingObject!.frame.size.height / 2
            expandingObject?.center = startPoint
            expandingObject?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            expandingObject?.backgroundColor = transitionColor
            originalView.addSubview(expandingObject!)
            
            presentingView.center = startPoint
            presentingView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentingView.alpha = 0
            originalView.addSubview(presentingView)
            UIView.animate(withDuration: duration, animations: { 
                self.expandingObject?.transform = CGAffineTransform.identity
                presentingView.transform = CGAffineTransform.identity
                presentingView.alpha = 1.0
                presentingView.center = originalCenter
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
            
        }else{
            let disappearingViewController = transitionContext.view(forKey: UITransitionContextViewKey.from)!
            let originalCenter = disappearingViewController.center
            let originalSize = disappearingViewController.frame.size
            
            
            if let expandingObject = expandingObject {
                
                let maxX = max(startPoint.x, originalSize.width -  startPoint.x)
                let maxY = max(startPoint.y, originalSize.height -  startPoint.y)
                let farthestCorner = sqrt(maxX * maxX + maxY * maxY) * 2

                expandingObject.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: farthestCorner, height: farthestCorner))
                expandingObject.center = self.startPoint
                expandingObject.layer.cornerRadius = expandingObject.frame.size.height / 2
            }
            
            UIView.animate(withDuration: duration, animations: { 
                self.expandingObject?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                disappearingViewController.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
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

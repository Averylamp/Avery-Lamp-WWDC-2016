//
//  AppCell.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/23/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class AppCell: UITableViewCell {
    
    @IBOutlet var highlightViews: [UIView]!
    
    @IBOutlet weak var closedView: UIView!
    
    @IBOutlet weak var openView: UIView!
    
    @IBOutlet var openViewContainers: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.None
        backgroundColor = UIColor.clearColor()
        let closedViewTopConstraint = self.contentView.constraints.filter{ $0.identifier == "closedViewTop"}.first
        let openViewTopConstraint = self.contentView.constraints.filter{ $0.identifier == "openViewTop"}.first
        
        openViewTopConstraint?.constant = (closedViewTopConstraint?.constant)!
        openView.alpha = 0.0
        
        highlightViews.forEach { $0.backgroundColor = UIColor(red: 0.961, green: 0.651, blue: 0.137, alpha: 1.00) }
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var isAnimating = false
    func openAnimation() {
        isAnimating = true
        UIView.animateWithDuration(0.3) {
            self.closedView.alpha = 0.0
            self.openView.alpha = 1.0
        }
        openViewContainers.forEach{ $0.alpha = 0.0}
        openViewContainers.first?.superview?.constraints.filter{ $0.identifier == "divisionTop"}.forEach { $0.constant = 30}
        openViewContainers.first?.superview?.layoutIfNeeded()
        for subview in openViewContainers {
            UIView.animateWithDuration(0.2, delay: Double(subview.tag) * 0.3, options: .CurveEaseInOut, animations: {
                subview.alpha = 1.0
                let topConstraint = subview.superview?.constraints.filter(){ if $0.identifier == "divisionTop"{
                    if(($0.firstItem as! NSObject == subview && $0.firstAttribute == .Top) || ($0.secondItem as! NSObject == subview && $0.secondAttribute == .Top)){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                    }
                }.first
                topConstraint?.constant = 0
                subview.superview?.layoutIfNeeded()
                }, completion: nil)
        }
        
        isAnimating = false
    }
    
    func closeAnimation(){
        isAnimating = true
        UIView.animateWithDuration(0.7) {
            self.closedView.alpha = 1.0
            self.openView.alpha = 0.0
        }
        isAnimating = false
    }
    
}

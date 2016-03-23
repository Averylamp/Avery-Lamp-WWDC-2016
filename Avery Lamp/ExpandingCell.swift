//
//  ExpandingCell.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/19/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
import FoldingCell

class ExpandingCell: FoldingCell {

    
    @IBOutlet var highlightViews: [UIView]!
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        foregroundView.clipsToBounds = true
        contentView.layer.cornerRadius = 10

        highlightViews.forEach{ $0.backgroundColor = UIColor(red: 0.961, green: 0.651, blue: 0.133, alpha: 1.00)}
        super.awakeFromNib()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
     override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26, 0.33, 0.33] // timing animation for each view
        return durations[itemIndex]
    }

}

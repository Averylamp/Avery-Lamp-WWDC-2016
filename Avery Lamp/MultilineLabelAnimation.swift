//
//  MultilineLabelAnimation.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/14/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class MultilineLabelAnimation: UIView {

    func setupLabels(string string:NSString, font:UIFont){
        
        let width = self.frame.width
        let attributes = [NSFontAttributeName: font]
        
        print("size \(string.sizeWithAttributes(attributes))\nLine Height \(font.lineHeight)")
        
        
    }

    
}

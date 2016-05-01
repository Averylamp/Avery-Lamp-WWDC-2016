//
//  ForceTouchButton.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 5/1/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ForceTouchButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var homeController:HomeViewController? = nil
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
    }
}

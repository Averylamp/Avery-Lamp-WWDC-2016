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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.homeController?.forceTouchDetected(touches.first!, button: self)
    }
}

//
//  UILabel+Drawing.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/10/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import Foundation


extension UILabel {
    
    func getPathOfText(onePath: Bool) ->[CGPath]{
        let font = CTFontCreateWithName(self.font.fontName as CFString, self.font.pointSize, nil)
        let attributes = NSDictionary(object: font, forKey: kCTFontAttributeName as String)
        let attributedString = NSAttributedString(string: self.text!, attributes: attributes as? [String : AnyObject])
        
        let line = CTLineCreateWithAttributedString(attributedString)
        let allRuns = CTLineGetGlyphRuns(line)
        let fullPath = CGPathCreateMutable()
        var allLetterPaths = Array<CGPath>()
        
        for runIndex in 0..<CFArrayGetCount(allRuns){
            let run:CTRun = (allRuns as NSArray)[runIndex] as! CTRun
            
            for glyphIndex in 0..<CTRunGetGlyphCount(run){
                let range = CFRangeMake(glyphIndex, 1)
                var glyph = CGGlyph()
                var position = CGPointZero
                
                CTRunGetGlyphs(run, range, &glyph)
                CTRunGetPositions(run, range, &position)
                
                let pathOfLetter = CTFontCreatePathForGlyph(font, glyph, nil)
                var transformation = CGAffineTransformMakeTranslation(position.x, position.y)
                let tempPath = CGPathCreateMutable()
                CGPathAddPath(tempPath, &transformation, pathOfLetter)
                allLetterPaths.append(tempPath)
                CGPathAddPath(fullPath, &transformation, pathOfLetter)
            }
            
        }
        if onePath{
           return  [fullPath]
        }else{
            return allLetterPaths
        }
    }
    
    
    func strokeTextAnimated(width width:CGFloat = 0.5,delay:Double = 0.0 , duration:Double, fade:Bool){
        
        if delay != 0.0{
            self.alpha = 0.0
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.alpha = 1.0
                self.strokeTextAnimated(width: width, delay: 0.0, duration: duration, fade: fade)
            })
            return
        }
        
        self.baselineAdjustment = .AlignBaselines
        let originalCenter = self.center
        self.sizeToFit()
        self.center = originalCenter
        self.layer.opacity = 0.0
        
        let bezierPath = UIBezierPath()
        bezierPath.appendPath(UIBezierPath(CGPath: getPathOfText(true).first!))
        
        let fullLabelShape = CAShapeLayer()
        fullLabelShape.frame = self.layer.frame
        fullLabelShape.bounds = self.layer.bounds
        fullLabelShape.path = getPathOfText(true).first!
        fullLabelShape.strokeColor = UIColor.blackColor().CGColor
        fullLabelShape.geometryFlipped = true
        fullLabelShape.fillColor = UIColor.clearColor().CGColor
        fullLabelShape.lineWidth = width
        fullLabelShape.lineJoin = kCALineJoinRound
        fullLabelShape.position = CGPointMake(fullLabelShape.position.x, fullLabelShape.position.y + self.font.descender)

        self.layer.superlayer?.addSublayer(fullLabelShape)
        
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = duration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock { 
            if fade {
                CATransaction.begin()
                CATransaction.setCompletionBlock({ 
                    fullLabelShape.removeFromSuperlayer()
                })
                UIView.animateWithDuration(1.0, animations: {
                    self.layer.opacity = 1.0
                })
                fullLabelShape.addAnimation(fadeOutAnimation, forKey: "fadeOut")
                CATransaction.commit()
            }
        }
        fullLabelShape.addAnimation(strokeAnimation, forKey: "strokeEnd")
        CATransaction.commit()
        
    }
    
    func strokeTextSimultaneously(width width:CGFloat = 0.5, delay:Double = 0.0, duration: Double, fade:Bool){
        
        if delay != 0.0{
            self.alpha = 0.0
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.alpha = 1.0
                self.strokeTextSimultaneously(width: width, delay: 0.0, duration: duration, fade: fade)
            })
            return
        }
        
        self.baselineAdjustment = .AlignBaselines
        let originalCenter = self.center
        self.sizeToFit()
        self.center = originalCenter
        self.layer.opacity = 0.0
        
        let allLetterPaths = getPathOfText(false)
        var allLetterShapes = Array<CAShapeLayer> ()
        for index in 0..<allLetterPaths.count {
            let singleLetterShape = CAShapeLayer()
            singleLetterShape.frame = self.layer.frame
            singleLetterShape.bounds = self.layer.bounds
            singleLetterShape.path = allLetterPaths[index]
            singleLetterShape.strokeColor = UIColor.blackColor().CGColor
            singleLetterShape.geometryFlipped = true
            singleLetterShape.fillColor = UIColor.clearColor().CGColor
            singleLetterShape.lineWidth = width
            singleLetterShape.lineJoin = kCALineJoinRound
            singleLetterShape.position = CGPointMake(singleLetterShape.position.x, singleLetterShape.position.y + self.font.descender)
            self.layer.superlayer?.addSublayer(singleLetterShape)
            allLetterShapes.append(singleLetterShape)
        }
        
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = duration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            if fade {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    allLetterShapes.forEach { $0.removeFromSuperlayer()}
                })
                UIView.animateWithDuration(1.0, animations: {
                    self.layer.opacity = 1.0
                })
                allLetterShapes.forEach { $0.addAnimation(fadeOutAnimation, forKey: "strokeEnd")}
                CATransaction.commit()
            }
        }
        allLetterShapes.forEach { $0.addAnimation(strokeAnimation, forKey: "strokeEnd")}
        
        CATransaction.commit()
        
        }
    
}




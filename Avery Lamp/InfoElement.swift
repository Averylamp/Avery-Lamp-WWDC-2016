//
//  InfoElement.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/16/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
import LTMorphingLabel

class InfoElement: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var viewData:JSON! = nil
    var buttonLabel = UIButton()
    var backgroundImage = UIImageView()
    var sideLeft = true
    var detailInfoView: UIView?
    var detailInfoLabel: LTMorphingLabel?
    
    
    func createLayout(left left: Bool){
        self.sideLeft = left
        let finalHeight = self.frame.width * ratioToFit
//        print("Final Height - \(finalHeight)  \nCurrent Height -\(self.frame.height)")
        
        if  finalHeight > self.frame.height {
            print("ENCLOSING VIEW OF INFO ELEMENT TOO SMALL")
//            self.frame = CGRect(origin: self.frame.origin, size: CGSizeMake(self.frame.width, finalHeight))
        }
//        self.addSubview(buttonLabel)
//        self.addSubview(backgroundImage)
        setInfo()
        createAutolayout(left)
        
        buttonLabel.addTarget(self, action: #selector(InfoElement.buttonClicked), forControlEvents: .TouchUpInside)

    }

    func buttonClicked() {
        print("Button Clicked")
    }
    
    private func setInfo(){
        buttonLabel.backgroundColor = UIColor(rgba: viewData["HighlightColor"].string! + "CC")
//        buttonLabel.setImage(getImageWithColor(UIColor(rgba: viewData["HighlightColor"].string!)), forState: .Normal)
//        buttonLabel.alpha = 0.7
        
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.text = viewData["SectionTitle"].string
        sectionTitleLabel.textAlignment = .Left
        let font = UIFont(name: "Lato-Semibold", size: 26)
        sectionTitleLabel.font = font
        sectionTitleLabel.adjustsFontSizeToFitWidth = true
        sectionTitleLabel.minimumScaleFactor = 0.5
        sectionTitleLabel.numberOfLines = 0
        sectionTitleLabel.lineBreakMode = .ByWordWrapping
        sectionTitleLabel.textColor = UIColor.whiteColor()
        buttonLabel.addSubview(sectionTitleLabel)
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leftIndent:CGFloat = 0.1
        
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitleLabel, attribute: .Top, relatedBy: .Equal, toItem: buttonLabel, attribute: .Bottom, multiplier: 0.3, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitleLabel, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 0.2, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitleLabel, attribute: .Left, relatedBy: .Equal, toItem: buttonLabel, attribute: .Right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitleLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Width, multiplier: 1 - leftIndent - 0.1, constant: 0))

        let sectionSubtitleLabel = UILabel()
        sectionSubtitleLabel.text = viewData["SectionSubtitle"].string
        sectionSubtitleLabel.textAlignment = .Left
        sectionSubtitleLabel.font = UIFont(name: "Lato-Regular", size: 16)
        sectionSubtitleLabel.adjustsFontSizeToFitWidth = true
        sectionSubtitleLabel.minimumScaleFactor = 0.5
        sectionSubtitleLabel.numberOfLines = 0
        sectionSubtitleLabel.lineBreakMode = .ByWordWrapping
        sectionSubtitleLabel.textColor = UIColor.whiteColor()
        buttonLabel.addSubview(sectionSubtitleLabel)
        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitleLabel, attribute: .Top, relatedBy: .Equal, toItem: buttonLabel, attribute: .Bottom, multiplier: 0.5, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitleLabel, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 0.3, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitleLabel, attribute: .Left, relatedBy: .Equal, toItem: buttonLabel, attribute: .Right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitleLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Width, multiplier: 1.0 - leftIndent - 0.1, constant: 0))
        
        backgroundImage.image = UIImage(named:  viewData["BackgroundImage"].string!)
        backgroundImage.contentMode = .ScaleAspectFill
        backgroundImage.clipsToBounds = true
        
        
    }
    
    var ratioToFit:CGFloat = 0.65
    
    private func createAutolayout(left: Bool){
        self.addSubview(backgroundImage)
        self.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.layer.shadowOffset = CGSizeMake(0, 15)
        buttonLabel.layer.shadowColor = UIColor.blackColor().CGColor
        buttonLabel.layer.shadowRadius = 20
        buttonLabel.layer.shadowOpacity = 0.5
        
        backgroundImage.layer.shadowOffset = CGSizeMake(0, 15)
        backgroundImage.layer.shadowColor = UIColor.blackColor().CGColor
        backgroundImage.layer.shadowRadius = 10
        backgroundImage.layer.shadowOpacity = 0.6
        
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 0.85, constant: 1.0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: ratioToFit, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        if left{
            self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0))
        }else{
            self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0))
        }
        
        
        
    }
    
    func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 100, 100)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

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
    var detailInfoLabel: UILabel?
    var sectionTitle: UILabel! = nil
    var sectionSubtitle: UILabel! = nil
    
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
        
        sectionTitle = UILabel()
        sectionTitle.text = viewData["SectionTitle"].string
        sectionTitle.textAlignment = .Left
        let font = UIFont(name: "Lato-Semibold", size: 26)
        sectionTitle.font = font
        sectionTitle.adjustsFontSizeToFitWidth = true
        sectionTitle.minimumScaleFactor = 0.8
        sectionTitle.numberOfLines = 2
        sectionTitle.textColor = UIColor.whiteColor()
        buttonLabel.addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let leftIndent:CGFloat = 0.1
        
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .Top, relatedBy: .Equal, toItem: buttonLabel, attribute: .Bottom, multiplier: 0.25, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 0.3, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .Left, relatedBy: .Equal, toItem: buttonLabel, attribute: .Right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Width, multiplier: 1 - leftIndent - 0.1, constant: 0))

        sectionSubtitle = UILabel()
        sectionSubtitle.text = viewData["SectionSubtitle"].string
        sectionSubtitle.textAlignment = .Left
        sectionSubtitle.font = UIFont(name: "Lato-Regular", size: 16)
        sectionSubtitle.adjustsFontSizeToFitWidth = true
        sectionSubtitle.minimumScaleFactor = 0.5
        sectionSubtitle.numberOfLines = 0
        sectionSubtitle.lineBreakMode = .ByWordWrapping
        sectionSubtitle.textColor = UIColor.whiteColor()
        buttonLabel.addSubview(sectionSubtitle)
        sectionSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .Top, relatedBy: .Equal, toItem: buttonLabel, attribute: .Bottom, multiplier: 0.5, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .Height, relatedBy: .Equal, toItem: buttonLabel, attribute: .Height, multiplier: 0.35, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .Left, relatedBy: .Equal, toItem: buttonLabel, attribute: .Right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .Width, relatedBy: .Equal, toItem: buttonLabel, attribute: .Width, multiplier: 1.0 - leftIndent - 0.05, constant: 0))
        
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
        backgroundImage.layer.cornerRadius = 5
        
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

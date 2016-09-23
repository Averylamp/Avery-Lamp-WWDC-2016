//
//  InfoElement.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/16/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit
//import LTMorphingLabel

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
    
    func createLayout(_ left: Bool){
        self.sideLeft = left
        let finalHeight = self.frame.width * ratioToFit
        
        if  finalHeight > self.frame.height {
            print("ENCLOSING VIEW OF INFO ELEMENT TOO SMALL")
//            self.frame = CGRect(origin: self.frame.origin, size: CGSizeMake(self.frame.width, finalHeight))
        }
//        self.addSubview(buttonLabel)
//        self.addSubview(backgroundImage)
        setInfo()
        createAutolayout(left)

    }

    fileprivate func setInfo(){
        buttonLabel.backgroundColor = UIColor(rgba: viewData["HighlightColor"].string! + "CC")
//        buttonLabel.setImage(getImageWithColor(UIColor(rgba: viewData["HighlightColor"].string!)), forState: .Normal)
//        buttonLabel.alpha = 0.7
        
        sectionTitle = UILabel()
        sectionTitle.text = viewData["SectionTitle"].string
        sectionTitle.textAlignment = .left
        let font = UIFont(name: "Lato-Semibold", size: 26)
        sectionTitle.font = font
        sectionTitle.adjustsFontSizeToFitWidth = true
        sectionTitle.minimumScaleFactor = 0.8
        sectionTitle.numberOfLines = 2
        sectionTitle.textColor = UIColor.white
        buttonLabel.addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let leftIndent:CGFloat = 0.1
        
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .top, relatedBy: .equal, toItem: buttonLabel, attribute: .bottom, multiplier: 0.25, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .height, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 0.3, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .left, relatedBy: .equal, toItem: buttonLabel, attribute: .right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionTitle, attribute: .width, relatedBy: .equal, toItem: buttonLabel, attribute: .width, multiplier: 1 - leftIndent - 0.1, constant: 0))

        sectionSubtitle = UILabel()
        sectionSubtitle.text = viewData["SectionSubtitle"].string
        sectionSubtitle.textAlignment = .left
        sectionSubtitle.font = UIFont(name: "Lato-Regular", size: 16)
        sectionSubtitle.adjustsFontSizeToFitWidth = true
        sectionSubtitle.minimumScaleFactor = 0.5
        sectionSubtitle.numberOfLines = 0
        sectionSubtitle.lineBreakMode = .byWordWrapping
        sectionSubtitle.textColor = UIColor.white
        buttonLabel.addSubview(sectionSubtitle)
        sectionSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .top, relatedBy: .equal, toItem: buttonLabel, attribute: .bottom, multiplier: 0.5, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .height, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 0.35, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .left, relatedBy: .equal, toItem: buttonLabel, attribute: .right, multiplier: leftIndent, constant: 0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: sectionSubtitle, attribute: .width, relatedBy: .equal, toItem: buttonLabel, attribute: .width, multiplier: 1.0 - leftIndent - 0.05, constant: 0))
        
        backgroundImage.image = UIImage(named:  viewData["BackgroundImage"].string!)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        
    }
    
    var ratioToFit:CGFloat = 0.65
    
    fileprivate func createAutolayout(_ left: Bool){
        self.addSubview(backgroundImage)
        self.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.layer.shadowOffset = CGSize(width: 0, height: 15)
        buttonLabel.layer.shadowColor = UIColor.black.cgColor
        buttonLabel.layer.shadowRadius = 20
        buttonLabel.layer.shadowOpacity = 0.5
        
        backgroundImage.layer.shadowOffset = CGSize(width: 0, height: 15)
        backgroundImage.layer.shadowColor = UIColor.black.cgColor
        backgroundImage.layer.shadowRadius = 10
        backgroundImage.layer.shadowOpacity = 0.6
        backgroundImage.layer.cornerRadius = 5
        
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .height, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 0.85, constant: 1.0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .width, relatedBy: .equal, toItem: buttonLabel, attribute: .height, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratioToFit, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        if left{
            self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        }else{
            self.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        }
        
        
        
    }
    
    func getImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

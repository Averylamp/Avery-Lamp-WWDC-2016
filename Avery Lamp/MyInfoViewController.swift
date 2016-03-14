//
//  MyInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class MyInfoViewController: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        pageScrollView = UIScrollView(frame: CGRectMake(0,0,width, height))
        pageScrollView.pagingEnabled = true
        pageScrollView.contentSize = CGSizeMake( width * 4, height)
        pageScrollView.delegate = self
        self.view.addSubview(pageScrollView)
        
        
        let borderWidth = CGFloat(30)
        firstPage = UIView(frame: CGRectMake(width + borderWidth, 0 + borderWidth, width - borderWidth * 2 , height - borderWidth * 2))
        firstPage.layer.borderWidth = 2
        firstPage.layer.borderColor = UIColor.blackColor().CGColor
        pageScrollView.addSubview(firstPage)
        let label = UILabel(frame: CGRectMake(0,0,firstPage.frame.width, 100))
        label.text = "Avery Lamp"
        label.font = UIFont(name: "Panton-Regular", size: 40)
        firstPage.addSubview(label)
        
        
    }
    
    var firstPage = UIView()

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        let xRotate = (scrollView.contentOffset.x / width) - 1
        var perpectiveTransform = CATransform3DIdentity
        perpectiveTransform.m34 = -1.0 / width
        
        let rotateX = CATransform3DMakeRotation(CGFloat(M_PI_4) , 0, xRotate, 0)
        self.firstPage.layer.transform = CATransform3DConcat(perpectiveTransform, rotateX)
        
        
        print(xRotate)
    }
    
    var pageScrollView = UIScrollView()

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

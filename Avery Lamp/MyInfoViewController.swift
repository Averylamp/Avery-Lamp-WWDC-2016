//
//  MyInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class MyInfoViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var jsonData:JSON! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.463, green: 0.486, blue: 0.549, alpha: 1.00)
        setupJSON()
//        print(jsonData["InfoSections"].count)
        let numberOfPages = Int(ceil(Double(jsonData["InfoSections"].count) / 2.0))
        pageControl.numberOfPages = numberOfPages
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(numberOfPages), scrollView.frame.height)
        scrollView.delegate = self
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(pageControl.numberOfPages), scrollView.frame.height)
    }
    
    func setupJSON(){
        if let path = NSBundle.mainBundle().pathForResource("InfoData", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonData = JSON(data: data)
                if jsonData != JSON.null {
                    //                    print("jsonData:\(jsonData["Apps"])")
                } else {
                    print("could not get json")
                }
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("file not found")
        }
    }

    
    //MARK: -ScrollView Delegate Functions
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let fractionalPage = self.scrollView.contentOffset.x / scrollView.frame.width
        let page = Int(round(fractionalPage))
        pageControl.currentPage = page
    }
    
    
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

    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

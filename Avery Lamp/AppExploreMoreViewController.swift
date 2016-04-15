//
//  AppExploreMoreViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/27/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class AppExploreMoreViewController: UIViewController {

    var exploreMoreInfo:JSON?
    
    @IBOutlet var themeLabels: [UILabel]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if exploreMoreInfo != nil{
            scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(exploreMoreInfo!["expandedDetails"].count), scrollView.frame.height)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.pagingEnabled = true
//        print("More Info Data \(exploreMoreInfo)")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        print("More Info Data TAKE 2 \(exploreMoreInfo)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

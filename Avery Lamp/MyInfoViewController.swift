//
//  MyInfoViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/3/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit


class MyInfoViewController: UIViewController,UIScrollViewDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var jsonData:JSON! = nil
    
    var InfoElements = [InfoElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.463, green: 0.486, blue: 0.549, alpha: 1.00)
        setupJSON()
        let numberOfPages = Int(ceil(Double(jsonData["InfoSections"].count) / 2.0))
        var numberOfSections = jsonData["InfoSections"].count
        pageControl.numberOfPages = numberOfPages
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(numberOfPages), height: scrollView.frame.height)
        scrollView.delegate = self
        
//        scrollView.layer.borderWidth = 2
//        scrollView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        var lastPage:UIView?
        for index in 0..<numberOfPages{
            let page = UIView()
            page.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(page)
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0))
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0))
            scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .centerY, relatedBy: .equal, toItem: scrollView, attribute: .centerY, multiplier: 1.0, constant: 0))
            if index == 0{
                scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0))
            }else{
                scrollView.addConstraint(NSLayoutConstraint(item: page, attribute: .left, relatedBy: .equal, toItem: lastPage, attribute: .right, multiplier: 1.0, constant: 0))
            }
            lastPage = page

            let widthRatio:CGFloat = 0.9
            
            let topSection = InfoElement()
            topSection.tag = index * 2 + 1000
            topSection.buttonLabel.tag = index * 2
            topSection.buttonLabel.addTarget(self, action: #selector(MyInfoViewController.expandInfoSectionClicked(_:)), for: .touchUpInside)
            topSection.viewData = jsonData["InfoSections"][index * 2]
            topSection.translatesAutoresizingMaskIntoConstraints = false
            page.addSubview(topSection)
            
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .top, relatedBy: .equal, toItem: page, attribute: .top, multiplier: 1.0, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .centerX, relatedBy: .equal, toItem: page, attribute: .centerX, multiplier: 1.0, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .width, relatedBy: .equal, toItem: page, attribute: .width, multiplier: widthRatio, constant: 0))
            page.addConstraint(NSLayoutConstraint(item: topSection, attribute: .height, relatedBy: .equal, toItem: page, attribute: .height, multiplier: 0.48, constant: 0))
            
            InfoElements.append(topSection)
            numberOfSections -= 1
            
            if numberOfSections > 0{
                
                let bottomSection = InfoElement()
                bottomSection.viewData = jsonData["InfoSections"][index * 2 + 1]
                bottomSection.tag = index * 2 + 1 + 1000
                bottomSection.buttonLabel.tag = index * 2 + 1
                bottomSection.buttonLabel.addTarget(self, action: #selector(MyInfoViewController.expandInfoSectionClicked(_:)), for: .touchUpInside)
                bottomSection.translatesAutoresizingMaskIntoConstraints = false
                page.addSubview(bottomSection)
                
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .top, relatedBy: .equal, toItem: topSection, attribute: .bottom, multiplier: 1.0, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .centerX, relatedBy: .equal, toItem: page, attribute: .centerX, multiplier: 1.0, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .width, relatedBy: .equal, toItem: page, attribute: .width, multiplier: widthRatio, constant: 0))
                page.addConstraint(NSLayoutConstraint(item: bottomSection, attribute: .height, relatedBy: .equal, toItem: page, attribute: .height, multiplier: 0.48, constant: 0))
                InfoElements.append(bottomSection)
                
                numberOfSections -= 1
            }
            
        }
        
        InfoElements.forEach {
//            $0.layoutIfNeeded()
            if $0.tag % 2 == 0 {
                $0.createLayout(true)
            }else{
                $0.createLayout(false)
            }
        }
    }
    
    func setupJSON(){
        if let path = Bundle.main.path(forResource: "InfoData", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
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
    
    func expandInfoSectionClicked(_ button: UIButton){
        let clickedInfoElement = scrollView.viewWithTag(button.tag + 1000) as! InfoElement
        indexOfClickedElement = button.tag
        infoTransitionAnimator.infoSectionToExpand = clickedInfoElement
        self.performSegue(withIdentifier: "expandedInfoSegue", sender: self)
    }
    var indexOfClickedElement:Int = 0
    
    let infoTransitionAnimator = InfoTransition()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ExpandedInfoViewController {
            destinationController.transitioningDelegate = self
            destinationController.modalPresentationStyle = .custom
            destinationController.viewData = jsonData["InfoSections"][indexOfClickedElement]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageControl.numberOfPages), height: scrollView.frame.height)
        
    }
    
    //MARK: -ScrollView Delegate Functions
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fractionalPage = self.scrollView.contentOffset.x / scrollView.frame.width
        let page = Int(round(fractionalPage))
        pageControl.currentPage = page
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        infoTransitionAnimator.transitionMode = .present
        return infoTransitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        infoTransitionAnimator.transitionMode = .dismiss
        return infoTransitionAnimator
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonClicked(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}

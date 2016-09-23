//
//  MyAppsTableViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/6/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class MyAppsTableViewController: UITableViewController, UIViewControllerTransitioningDelegate{

    
    var rowNumber = 6
    var cellHeights: [CGFloat] = [CGFloat]()
    let closedCellHeight: CGFloat = 150 + 16
    var openedCellHeight: CGFloat = 630 + 16 // 630 + 16 for iPhone 6 /515 + 16 for iPhone 5
    var cellType = "AppCell"
    var jsonData: JSON! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 0.678, green: 0.922, blue: 0.973, alpha: 1.00)
        for _ in 0...rowNumber {
            cellHeights.append(closedCellHeight)
        }
        let screenHeight = UIScreen.main.bounds.height
        
        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width, height: 60))
        headerView.backgroundColor = tableView.backgroundColor
        tableView.tableHeaderView = headerView
        
        let myProjectsTitle = UILabel(frame: CGRect(x: 0,y: 20,width: self.view.frame.width, height: 40))
        myProjectsTitle.text = "My Projects"
        myProjectsTitle.textAlignment = .center
        myProjectsTitle.font = UIFont(name: "ADAM.CG PRO", size: 30)
        headerView.addSubview(myProjectsTitle)
        
        let backButton = UIButton(frame: CGRect(x: 20,y: 20,width: 40,height: 40))
        backButton.center = CGPoint(x: backButton.center.x, y: myProjectsTitle.center.y)
        backButton.setImage(UIImage(named: "backArrow"), for: UIControlState())
        backButton.addTarget(self, action: #selector(MyAppsTableViewController.backButtonClicked), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        if screenHeight > 630 {
            openedCellHeight = 630 + 16 

        }else {
            cellType = "AppCell2"
            openedCellHeight = 515 + 16
        }
        setupJSON()
        rowNumber = jsonData["Apps"].count
        tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupJSON(){
        if let path = Bundle.main.path(forResource: "AppData", ofType: "json"){
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowNumber
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AppCell
        if cellHeights[(indexPath as NSIndexPath).row] == closedCellHeight {
            cell.openAnimation(true)
            cellHeights[(indexPath as NSIndexPath).row] = openedCellHeight
        }else{
            cell.closeAnimation(true)
            cellHeights[(indexPath as NSIndexPath).row] = closedCellHeight
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: { 
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
            }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is AppCell{
            let appCell = cell as! AppCell
            if cellHeights[(indexPath as NSIndexPath).row] == closedCellHeight {
                appCell.closeAnimation(false)
            }else{
                appCell.openAnimation(false)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! AppCell
        if cell.titleLabels != nil{
            cell.titleLabels.forEach { $0.text = jsonData["Apps"][(indexPath as NSIndexPath).row]["title"].string!}
            cell.taglineLabels.forEach { $0.text = jsonData["Apps"][(indexPath as NSIndexPath).row]["tagline"].string!}
            cell.shortDescriptionLabels.forEach { $0.text = jsonData["Apps"][(indexPath as NSIndexPath).row]["shortDescription"].string!}
            cell.appIcons.forEach{ $0.image = UIImage(named: jsonData["Apps"][(indexPath as NSIndexPath).row]["appIconImage"].string!)}
            cell.highlightViews.forEach{ $0.backgroundColor = UIColor(rgba:jsonData["Apps"][(indexPath as NSIndexPath).row]["highlightColor"].string! )}
            cell.mediumDescriptionLabels.forEach{ $0.text = jsonData["Apps"][(indexPath as NSIndexPath).row]["mediumDescription"].string! }
            cell.longDescriptionLabels.forEach{ $0.text = jsonData["Apps"][(indexPath as NSIndexPath).row]["longDescription"].string! }
            if cell.detailPictures != nil {
                cell.detailPictures.forEach{ $0.image = UIImage(named: jsonData["Apps"][(indexPath as NSIndexPath).row]["appDetailImage"].string!)}
            }
            
            cell.exploreMoreButtons.forEach{
                $0.tag = (indexPath as NSIndexPath).row
                $0.addTarget(self, action: #selector(MyAppsTableViewController.exploreMoreButtonClicked(_:)), for: UIControlEvents.touchUpInside) }
            
        }
        return cell
    }
    
    func exploreMoreButtonClicked(_ button: UIButton){
        exploreMoreButtonClicked = button

        self.performSegue(withIdentifier: "exploreMoreSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AppExploreMoreViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.view.backgroundColor = exploreMoreButtonClicked?.backgroundColor
            controller.view.layoutIfNeeded()
            controller.scrollView.layoutIfNeeded()
            controller.exploreMoreInfo = jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]
            controller.titleLabel.text = jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["title"].string
            controller.taglineLabel.text = jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["tagline"].string
            controller.shortDescriptionLabel.text = jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["shortDescription"].string
            if jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["extraInfoLink"].string != nil {
                controller.moreInfoButton.setTitle("Link for \(jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["extraInfoType"].string!)", for: UIControlState())
            }else{
                controller.moreInfoButton.alpha = 0.0
            }
            
            if jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["theme"].string == "light"{
                controller.themeLabels.forEach{ $0.textColor = UIColor.black}
            }else{
                controller.themeLabels.forEach{ $0.textColor = UIColor.white}
            }
            if let expandingInfo:JSON? = jsonData["Apps"][(exploreMoreButtonClicked?.tag)!]["expandedDetails"] {
                controller.scrollView.isPagingEnabled = true
                controller.scrollView.contentSize = CGSize(width: controller.scrollView.frame.width * CGFloat(expandingInfo!.count), height: controller.scrollView.frame.height)
                
                var lastSlide: UIView?
                for index in 0..<expandingInfo!.count {
                    if expandingInfo![index]["style"].string != ""{
                        let slide = UIView()
                        let slideViewController = AppExploreMoreSlideViewController()
                        slideViewController.slideNumber = index
                        slideViewController.view = slide
                        controller.slideViewControllers.append(slideViewController)
                        
                        slide.translatesAutoresizingMaskIntoConstraints = false
                        
                        controller.scrollView.addSubview(slide)
                        controller.scrollView.addConstraint(NSLayoutConstraint(item: slide, attribute: .height, relatedBy: .equal, toItem: controller.scrollView, attribute: .height, multiplier: 1.0, constant: 0))
                        controller.scrollView.addConstraint(NSLayoutConstraint(item: slide, attribute: .width, relatedBy: .equal, toItem: controller.scrollView, attribute: .width, multiplier: 1.0, constant: 0))
                        controller.scrollView.addConstraint(NSLayoutConstraint(item: slide, attribute: .centerY, relatedBy: .equal, toItem: controller.scrollView, attribute: .centerY, multiplier: 1.0, constant: 0))
                        if index == 0 {
                            controller.scrollView.addConstraint(NSLayoutConstraint(item: slide, attribute: .left, relatedBy: .equal, toItem: controller.scrollView, attribute: .left, multiplier: 1.0, constant: 0))
                        }else{
                            controller.scrollView.addConstraint(NSLayoutConstraint(item: slide, attribute: .left, relatedBy: .equal, toItem: lastSlide, attribute: .right, multiplier: 1.0, constant: 0))
                        }
                        slide.layoutIfNeeded()
                        slideViewController.slideData = expandingInfo![index]
                        slideViewController.createViewsWithLayouts()
                        lastSlide = slide
                        
                    }
                    
                }
                
            }
            
            
        }
    }
    
    let expandingTransition = ExpandingTransition()
    var exploreMoreButtonClicked:UIButton?
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        expandingTransition.transitionMode = .present
        let pointInVC = exploreMoreButtonClicked!.convert(exploreMoreButtonClicked!.center, to: nil)
//            self.view.convertPoint(exploreMoreButtonClicked!.center, fromView: exploreMoreButtonClicked)
        expandingTransition.startPoint = CGPoint(x: self.view.frame.width / 2, y: pointInVC.y)
//        print("Transition Center : \(pointInVC)\nBounds of View \(self.view.bounds)\nBounds of Center \(exploreMoreButtonClicked?.bounds)")
        expandingTransition.transitionColor = exploreMoreButtonClicked!.backgroundColor!
        return expandingTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        expandingTransition.transitionMode = .dismiss
        let pointInVC = exploreMoreButtonClicked!.convert(exploreMoreButtonClicked!.center, to: nil)
        expandingTransition.startPoint = CGPoint(x: self.view.frame.width / 2, y: pointInVC.y)
        expandingTransition.transitionColor = exploreMoreButtonClicked!.backgroundColor!
        return expandingTransition

    }
    
    func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

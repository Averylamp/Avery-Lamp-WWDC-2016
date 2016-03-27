//
//  MyAppsTableViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/23/16.
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
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        if screenHeight > 630 {
            openedCellHeight = 630 + 16 

        }else {
            cellType = "AppCell2"
            openedCellHeight = 515 + 16
        }
        setupJSON()
        rowNumber = jsonData["Apps"].count
        tableView.separatorStyle = .None
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupJSON(){
        if let path = NSBundle.mainBundle().pathForResource("AppData", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonData = JSON(data: data)
                if jsonData != JSON.null {
                    print("jsonData:\(jsonData["Apps"])")
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowNumber
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AppCell
        if cellHeights[indexPath.row] == closedCellHeight {
            cell.openAnimation(true)
            cellHeights[indexPath.row] = openedCellHeight
        }else{
            cell.closeAnimation(true)
            cellHeights[indexPath.row] = closedCellHeight
        }
        
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseOut, animations: { 
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell is AppCell{
            let appCell = cell as! AppCell
            if cellHeights[indexPath.row] == closedCellHeight {
                appCell.closeAnimation(false)
            }else{
                appCell.openAnimation(false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType, forIndexPath: indexPath) as! AppCell
        if cell.titleLabels != nil{
            cell.titleLabels.forEach { $0.text = jsonData["Apps"][indexPath.row]["title"].string!}
            cell.taglineLabels.forEach { $0.text = jsonData["Apps"][indexPath.row]["tagline"].string!}
            cell.shortDescriptionLabels.forEach { $0.text = jsonData["Apps"][indexPath.row]["shortDescription"].string!}
            cell.appIcons.forEach{ $0.image = UIImage(named: jsonData["Apps"][indexPath.row]["appIconImage"].string!)}
            cell.highlightViews.forEach{ $0.backgroundColor = UIColor(rgba:jsonData["Apps"][indexPath.row]["highlightColor"].string! )}
            cell.mediumDescriptionLabels.forEach{ $0.text = jsonData["Apps"][indexPath.row]["mediumDescription"].string! }
            cell.longDescriptionLabels.forEach{ $0.text = jsonData["Apps"][indexPath.row]["longDescription"].string! }
            if cell.detailPictures != nil {
                cell.detailPictures.forEach{ $0.image = UIImage(named: jsonData["Apps"][indexPath.row]["appDetailImage"].string!)}
            }
            
            cell.exploreMoreButtons.forEach{
                $0.tag = indexPath.row
                $0.addTarget(self, action: #selector(MyAppsTableViewController.exploreMoreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside) }
            
        }
        return cell
    }
    
    func exploreMoreButtonClicked(button: UIButton){
        exploreMoreButtonClicked = button
        print("\(button.backgroundColor)")
        self.performSegueWithIdentifier("exploreMoreSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? AppExploreMoreViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            
        }
    }
    
    let expandingTransition = ExpandingTransition()
    var exploreMoreButtonClicked:UIButton?
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        expandingTransition.transitionMode = .Present
        let pointInVC = exploreMoreButtonClicked!.convertPoint(exploreMoreButtonClicked!.center, toView: self.view)
//            self.view.convertPoint(exploreMoreButtonClicked!.center, fromView: exploreMoreButtonClicked)
        expandingTransition.startPoint = pointInVC
        print("Transition Center : \(pointInVC)")
        expandingTransition.transitionColor = exploreMoreButtonClicked!.backgroundColor!
        return expandingTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        expandingTransition.transitionMode = .Dismiss
        expandingTransition.startPoint = exploreMoreButtonClicked!.center
        expandingTransition.transitionColor = exploreMoreButtonClicked!.backgroundColor!
        return expandingTransition

    }
    
}

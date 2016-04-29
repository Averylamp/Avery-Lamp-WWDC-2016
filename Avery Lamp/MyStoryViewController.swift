//
//  MyStoryViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/3/16.
//  Copyright © diameter / 216 Avery Lamp. All rights reserved.
//

import UIKit
import MapKit
import LTMorphingLabel

class MyStoryViewController: UIViewController, MKMapViewDelegate {
    
    var jsonData:JSON! = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailTextLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    var rightButtonArrowLayer: CAShapeLayer?
    @IBOutlet weak var leftButton: UIButton!
    var leftButtonArrowLayer: CAShapeLayer?
    var currentPage = 0
    var pageChangeEnabled = false
    
    let counterLabel = LTMorphingLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupJSON()
        mapView.delegate = self
        
        mapView.mapType = MKMapType.HybridFlyover
        mapView.pitchEnabled = true
        mapView.showsCompass = false
        animateMap()
        let xCoord = jsonData[0]["xCoord"].doubleValue
        let yCoord = jsonData[0]["yCoord"].doubleValue
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(xCoord, yCoord), MKCoordinateSpanMake(0.002, 0.002))
        
        mapView.setRegion(region, animated: true)

        addAnnotations()
        drawButtons()
        detailImageView.contentMode = .ScaleAspectFit
        detailTextLabel.numberOfLines = 0
        detailTextLabel.lineBreakMode = .ByWordWrapping
        maxRadius = self.view.frame.width / 2
        detailImageView.image = UIImage(named: jsonData[currentPage]["DetailImage"].string!)
        view.bringSubviewToFront(detailTextLabel)
        loadText(index: currentPage)
        counterLabel.frame = CGRectMake(0, self.view.frame.height - 35, self.view.frame.width, 30)
        counterLabel.morphingDuration = 0.8
        counterLabel.textAlignment = .Center
        counterLabel.font = UIFont(name: "Panton-Light", size: 20)
        self.view.addSubview(counterLabel)
        counterLabel.text = "1/\(jsonData.count)"
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeRecognizer)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRecognizer)
        let firstOpen = NSUserDefaults.standardUserDefaults().valueForKey("FirstStoryOpen") as? Bool
        if firstOpen == nil{
            print("First Open")
            instructionsPopup()
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "FirstStoryOpen")
        }else if firstOpen == false{
            pageChangeEnabled = true
            print("Not first open")
        }
        setupLineOverlay()
    }
    var introView: UIView?
    
    func instructionsPopup() {
        let popupView = UIView(frame: CGRectMake(0,0,self.view.frame.width - 100, 400))
        popupView.layer.masksToBounds = true
        introView = popupView
        popupView.layer.cornerRadius = 20
        popupView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        popupView.alpha = 0.0
        self.view.addSubview(popupView)
        popupView.center = CGPointMake(self.view.center.x, self.view.center.y + 80)
        UIView.animateWithDuration(0.5, delay: 1.5, options: .CurveEaseOut, animations: {
            popupView.center = self.view.center
            popupView.alpha = 1.0
            }, completion: nil)
        
        let helloThereLabel = UILabel(frame: CGRectMake(0,0,popupView.frame.width,50))
        helloThereLabel.text = "Hello There"
        helloThereLabel.font = UIFont(name: "Panton-Semibold", size: 30)
        helloThereLabel.textAlignment = .Center
        popupView.addSubview(helloThereLabel)
        helloThereLabel.strokeTextAnimated(width: 0.8, delay: 2.0, duration: 1.0, fade: true)
        
        let welcomeToStoryLabel = UILabel(frame: CGRectMake(0,55,popupView.frame.width, 30))
        welcomeToStoryLabel.text = "Welcome to My Story"
        welcomeToStoryLabel.font = UIFont(name: "Panton-Regular", size: 20)
        welcomeToStoryLabel.textAlignment = .Center
        popupView.addSubview(welcomeToStoryLabel)
        welcomeToStoryLabel.strokeTextSimultaneously(width: 0.6, delay: 2.5, duration: 1.0, fade: true, returnStuff: false)
        
        let consiseStatement = UILabel(frame: CGRectMake(20, 80, popupView.frame.width - 40, 150))
        consiseStatement.numberOfLines = 0
        consiseStatement.lineBreakMode = .ByWordWrapping
        consiseStatement.text = "I will try to explain my story in as few words as possible, but quite frankly a lot has happened in the past year."
        consiseStatement.font = UIFont(name: "Panton-Regular", size: 20)
        popupView.addSubview(consiseStatement)
        consiseStatement.strokeTextLetterByLetter(width: 0.6, delay: 3.5, duration: 3.0, characterStrokeDuration: 1.0, fade: true, fadeDuration: 0.5, returnStuff: false)
        let morphingStatement = LTMorphingLabel(frame: CGRectMake(20,210,popupView.frame.width - 40, 60))
        morphingStatement.text = "By a lot, I mean..."
        morphingStatement.textAlignment = .Center
        morphingStatement.font = UIFont(name: "Panton-Regular", size: 20)
        popupView.addSubview(morphingStatement)
        morphingStatement.morphingEffect = .Fall
        morphingStatement.strokeTextLetterByLetter(width: 0.6, delay: 6.0, duration: 1.0, characterStrokeDuration: 0.5, fade: true, fadeDuration: 0.3, returnStuff: false)
        delay(8.0) {
            morphingStatement.frame = CGRectMake(20, 210, popupView.frame.width - 40, 60)
            morphingStatement.text = "I mean a tremendous amount"
        }
        delay(9.5) {
            morphingStatement.text = "Like 2 Internships"
        }
        delay(11.0) {
            morphingStatement.text = "10 Hackathons"
        }
        delay(12.5) {
            morphingStatement.text = "4 Years of Fun"
        }
        delay(14.0) {
            morphingStatement.text = "With Much More to Come"
        }
        
        let forceTouchLabel = UILabel(frame: CGRectMake(20, 270, popupView.frame.width - 40, 80))
        forceTouchLabel.numberOfLines = 0
        forceTouchLabel.lineBreakMode = .ByWordWrapping
        forceTouchLabel.text = "To see a picture for each location, force touch the text.\n"
        forceTouchLabel.font = UIFont(name: "Panton-Thin", size: 18)
        popupView.addSubview(forceTouchLabel)
        forceTouchLabel.strokeTextSimultaneously(width: 0.6, delay: 15.5, duration: 1.0, fade: false, returnStuff: false)
        
        let continueButton = UIButton(frame: CGRectMake(0,popupView.frame.height,popupView.frame.width, 60))
        continueButton.setTitle("Got it, tell me your story.", forState: .Normal)
        continueButton.backgroundColor = UIColor(rgba: "#3eba5e")
        popupView.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(MyStoryViewController.dismissIntro), forControlEvents: .TouchUpInside)
        UIView.animateWithDuration(1.0, delay: 17.0, options: .CurveEaseOut, animations: {
            continueButton.center = CGPointMake(continueButton.center.x, continueButton.center.y - 60)
            }, completion: nil)
        
    }
    
    func dismissIntro() {
        pageChangeEnabled = true
        UIView.animateWithDuration(1.0, animations: { 
            self.introView?.center = CGPointMake(self.introView!.center.x, self.introView!.center.y - 80)
            self.introView?.alpha = 0.0
            }) { (finished) in
                self.introView?.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    var camerasArray = [MKMapCamera]()
    
    
    func flyToLocation (location: CLLocationCoordinate2D, finalPitchCamera: MKMapCamera? = nil, flyoverAltitude:Double = 100, finalAltitude: Double = 100){
        let startCoord = self.mapView.camera.centerCoordinate
        let eyeCoord = CLLocationCoordinate2DMake(location.latitude, location.longitude)
//        let upCam = MKMapCamera(lookingAtCenterCoordinate: startCoord, fromEyeCoordinate: startCoord, eyeAltitude: flyoverAltitude)
        let turnCam = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: startCoord, eyeAltitude: flyoverAltitude)
//        let inCam = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude)
        if finalPitchCamera != nil{
            let inCam = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude * 2)
            camerasArray = [turnCam, inCam,finalPitchCamera!]
        }else{
            let inCam = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude)
            camerasArray = [turnCam, inCam]
        }
        goToNextCamera()
    }
    
    func goToNextCamera() {
        if camerasArray.count == 0{
            return
        }
        let nextCam = self.camerasArray.first
        self.camerasArray.removeAtIndex(0)
        UIView.animateWithDuration(2.0) {
            self.mapView.camera = nextCam!
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       goToNextCamera()
    }
    
    func addAnnotations(){
        for index in 0..<jsonData.count{
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(jsonData[index]["xCoord"].doubleValue, jsonData[index]["yCoord"].doubleValue)
            pointAnnotation.title = jsonData[index]["DetailTitle"].string
            pointAnnotation.subtitle = jsonData[index]["DetailSubtitle"].string
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    func setupJSON(){
        if let path = NSBundle.mainBundle().pathForResource("StoryData", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonData = JSON(data: data)
                if jsonData != JSON.null {
//                    print("jsonData:\(jsonData)")
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
    
    var labelStrokes = [CAShapeLayer]()
    
    func loadText(index index:Int)  {
        //        detailTextLabel.layer.superlayer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        detailTextLabel.text = jsonData[index]["DetailText"].string
        detailTextLabel.layoutIfNeeded()
        
        labelStrokes = detailTextLabel.strokeTextLetterByLetter(width: 0.6, delay: 0.0, duration: 3.0, characterStrokeDuration: 1.0, fade: false, fadeDuration: 0.3, returnStuff: true)
//        labelStrokes.forEach { $0.anchorPoint = CGPointMake(0.5, 0.5)}
    }
    
    func updateTextWithNewSlide(){
        let reverseStroke = CABasicAnimation(keyPath: "strokeEnd")
        reverseStroke.duration = 2.0
        reverseStroke.fromValue = 1.0
        reverseStroke.toValue = 0.0
        reverseStroke.fillMode = kCAFillModeForwards
        reverseStroke.removedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        CATransaction.setCompletionBlock({
            self.detailTextLabel.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            self.labelStrokes.forEach { $0.removeFromSuperlayer() }
            self.labelStrokes = [CAShapeLayer]()
            self.loadText(index: self.currentPage)
        })
        
        labelStrokes.forEach { $0.strokeEnd = 0 }
        
        CATransaction.commit()
        counterLabel.text = "\(currentPage + 1)/\(jsonData.count)"
        detailImageView.alpha = 0.0
        detailImageView.image = UIImage(named: jsonData[currentPage]["DetailImage"].string!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.locationInView(self.view)
        if CGRectContainsPoint(detailTextLabel.frame, locationInText){
            animateLabelWithTouch(touch, location: locationInText)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.locationInView(self.view)
        if CGRectContainsPoint(detailTextLabel.frame, locationInText){
            animateLabelWithTouch(touch, location: locationInText)
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.locationInView(self.view)
        
        animateLabelWithTouch(touch, location: locationInText,ended: true)
        
    }
    
    var maxRadius:CGFloat = 200.0
    var transitioningBetweenSlides = false
    func animateLabelWithTouch(touch:UITouch, location: CGPoint, ended: Bool = false){
        //        print("Location \(locationInText) Force - \(touch.force)")
        if transitioningBetweenSlides == false{
            labelStrokes.forEach {
//                $0.removeAllAnimations()
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(0.5)
                if ended == false{
                    $0.strokeEnd = min( (1 - touch.force / touch.maximumPossibleForce), 1.0)
                    detailImageView.layer.opacity = 1.0 - Float($0.strokeEnd)
                }else{
                    $0.strokeEnd = 1.0
                    detailImageView.layer.opacity = 0.0
                }
//                CATransaction.commit()
            }
        }
    }
    
    func drawButtons(){
        let diameter = rightButton.frame.width
        let fullRightPath = CGPathCreateMutable()
        let fullLeftPath = CGPathCreateMutable()
        let circlePathRight = UIBezierPath(arcCenter: CGPointMake(diameter / 2, diameter / 2), radius: diameter / 2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2 + M_PI * 2), clockwise: true)
        let circlePathLeft = UIBezierPath(arcCenter: CGPointMake(diameter / 2, diameter / 2), radius: diameter / 2, startAngle: CGFloat(M_PI_2 + M_PI * 2), endAngle: CGFloat(M_PI_2), clockwise: false)
        let arrowPath = UIBezierPath()
        arrowPath.moveToPoint(CGPointMake(diameter / 2, diameter))
        arrowPath.addLineToPoint(CGPointMake(diameter / 2, diameter / 4))
        arrowPath.addLineToPoint(CGPointMake(diameter * 3 / 4, diameter * 5 / 8))
        arrowPath.moveToPoint(CGPointMake(diameter / 2, diameter / 4))
        arrowPath.addLineToPoint(CGPointMake(diameter / 4, diameter * 5 / 8))
        
        
        CGPathAddPath(fullRightPath, nil, circlePathRight.CGPath)
//        CGPathAddPath(fullRightPath, nil, arrowPath.CGPath)
        CGPathAddPath(fullLeftPath, nil, circlePathLeft.CGPath)
//        CGPathAddPath(fullLeftPath, nil, arrowPath.CGPath)
        
        let drawPath = CABasicAnimation(keyPath: "strokeEnd")
        drawPath.fromValue = 0.0
        drawPath.toValue = 1.0
        drawPath.duration = 2.0
        let rightArrowShape = CAShapeLayer()
        rightArrowShape.path = arrowPath.CGPath
        rightArrowShape.fillColor = nil
        rightArrowShape.lineWidth = 1.0
        rightArrowShape.strokeColor = UIColor.blackColor().CGColor
        let leftArrowShape = CAShapeLayer()
        leftArrowShape.path = arrowPath.CGPath
        leftArrowShape.fillColor = nil
        leftArrowShape.lineWidth = 1.0
        leftArrowShape.strokeColor = UIColor.blackColor().CGColor
        
        let rightShapeLayer = CAShapeLayer()
        rightShapeLayer.path = fullRightPath
        rightShapeLayer.fillColor = nil
        rightShapeLayer.lineWidth = 1.0
        rightShapeLayer.strokeColor = UIColor.blackColor().CGColor
        let leftShapeLayer = CAShapeLayer()
        leftShapeLayer.path = fullLeftPath
        leftShapeLayer.fillColor = nil
        leftShapeLayer.lineWidth = 1.0
        leftShapeLayer.strokeColor = UIColor.blackColor().CGColor
        rightButton.layer.addSublayer(rightShapeLayer)
        leftButton.layer.addSublayer(leftShapeLayer)
        rightButton.layer.addSublayer(rightArrowShape)
        leftButton.layer.addSublayer(leftArrowShape)
        
        rightButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        leftButton.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        rightShapeLayer.addAnimation(drawPath, forKey: "path Animation")
        leftShapeLayer.addAnimation(drawPath, forKey: "Path Animation")
        rightArrowShape.addAnimation(drawPath, forKey: "path Animation")
        leftArrowShape.addAnimation(drawPath, forKey: "Path Animation")
        rightButtonArrowLayer = rightArrowShape
        leftButtonArrowLayer = leftArrowShape
    }
    
    func plusOnePath(right:Bool) -> CGPath{
        let width = rightButton.frame.width
        let plusOnePath = UIBezierPath()
        plusOnePath.moveToPoint(CGPointMake(0, width / 2))
        plusOnePath.addLineToPoint(CGPointMake(width / 3,  width / 2))
        plusOnePath.moveToPoint(CGPointMake(width / 6, width / 3))
        plusOnePath.addLineToPoint(CGPointMake(width / 6, width * 2 / 3))
        plusOnePath.moveToPoint(CGPointMake(0.6 * width, 0.2 * width))
        plusOnePath.addLineToPoint(CGPointMake(0.75 * width, 0.1 * width))
        plusOnePath.addLineToPoint(CGPointMake(0.75 * width, 0.8 * width))
        plusOnePath.moveToPoint(CGPointMake(0.5 * width, 0.8 * width))
        plusOnePath.addLineToPoint(CGPointMake(width, 0.8 * width))
        
        let bounds = CGPathGetBoundingBox(plusOnePath.CGPath)
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        plusOnePath.applyTransform(CGAffineTransformMakeTranslation(-center.x, -center.y))
        if right{
            plusOnePath.applyTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI_2)))
        }else{
            plusOnePath.applyTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        }
        plusOnePath.applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
        return plusOnePath.CGPath
    }
    
    func animateMap(){
        let nextLocation = CLLocationCoordinate2DMake(jsonData[currentPage]["xCoord"].doubleValue,jsonData[currentPage]["yCoord"].doubleValue )
        if jsonData[currentPage]["cam"] != nil {
            let camData = jsonData[currentPage]["cam"]
            let pitchCam = MKMapCamera(lookingAtCenterCoordinate: nextLocation, fromEyeCoordinate: CLLocationCoordinate2DMake(camData["xCoord"].doubleValue, camData["yCoord"].doubleValue), eyeAltitude: camData["altitude"].doubleValue)
            pitchCam.pitch = CGFloat(camData["pitch"].doubleValue)
            flyToLocation(nextLocation, finalPitchCamera: pitchCam , flyoverAltitude: jsonData[currentPage]["flyoverAltitude"].doubleValue, finalAltitude: camData["altitude"].doubleValue)
        }else{
            flyToLocation(nextLocation, finalPitchCamera: nil, flyoverAltitude: jsonData[currentPage]["flyoverAltitude"].doubleValue, finalAltitude: 80)
        }
        
    }
    
    
    func handleSwipe(gesture:UISwipeGestureRecognizer){
        if(gesture.direction == UISwipeGestureRecognizerDirection.Left){
            rightButtonClicked(UIView())
        }
        if(gesture.direction == UISwipeGestureRecognizerDirection.Right){
            leftButtonClicked(UIView())
        }
    }
    
    @IBAction func rightButtonClicked(sender: AnyObject) {
        if pageChangeEnabled == false{
            return
        }
        if currentPage < jsonData.count - 1{
            currentPage += 1
            animateMap()
            updateTextWithNewSlide()
            
            rightButtonArrowLayer?.removeAllAnimations()
            rightButtonArrowLayer?.position = CGPointMake(0, 0)
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.rightButtonArrowLayer?.position = CGPointMake(0, 0)
                CATransaction.begin()
                self.rightButtonArrowLayer?.opacity = 1.0
                CATransaction.commit()
            })
            CATransaction.setAnimationDuration(1.0)
            
            rightButtonArrowLayer?.position = CGPointMake(rightButtonArrowLayer!.position.x, rightButtonArrowLayer!.position.y - 20)
            rightButtonArrowLayer?.opacity = 0.0
            CATransaction.commit()
        }
        
    }
    
    @IBAction func leftButtonClicked(sender: AnyObject) {
        if pageChangeEnabled == false{
            return
        }
        if currentPage > 0{
            currentPage -= 1
            animateMap()
            updateTextWithNewSlide()
            
            leftButtonArrowLayer?.removeAllAnimations()
            leftButtonArrowLayer?.position = CGPointMake(0, 0)
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.leftButtonArrowLayer?.position = CGPointMake(0, 0)
                CATransaction.begin()
                self.leftButtonArrowLayer?.opacity = 1.0
                CATransaction.commit()
            })
            CATransaction.setAnimationDuration(1.0)
            
            leftButtonArrowLayer?.position = CGPointMake(leftButtonArrowLayer!.position.x, leftButtonArrowLayer!.position.y - 20)
            leftButtonArrowLayer?.opacity = 0.0
            CATransaction.commit()
        }
    }
    
    func setupLineOverlay() {
        return
        var coordinates = [CLLocationCoordinate2D]()
        for index in 0..<jsonData.count {
            let coordinate = CLLocationCoordinate2DMake(jsonData[index]["xCoord"].doubleValue, jsonData[index]["yCoord"].doubleValue)
            coordinates.append(coordinate)
        }
        routeLine = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.addOverlay(routeLine!)
    }

    var routeLine: MKPolyline? = nil
    var routeLineView:MKPolylineView? = nil
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(polyline: routeLine!)
        polylineRenderer.strokeColor = UIColor(rgba: "#3495f6")
        polylineRenderer.lineWidth = 1
        polylineRenderer.alpha = 0.6
        
        return polylineRenderer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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

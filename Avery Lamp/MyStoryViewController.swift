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
    var rightButtonStrokeLayer: CAShapeLayer?
    @IBOutlet weak var leftButton: UIButton!
    var leftButtonStrokeLayer: CAShapeLayer?
    var currentPage = 0
    
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
        counterLabel.morphingDuration = 1.0
        counterLabel.textAlignment = .Center
        counterLabel.font = UIFont(name: "Panton-Light", size: 20)
        self.view.addSubview(counterLabel)
        counterLabel.text = "1/\(jsonData.count)"
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
                    print("jsonData:\(jsonData)")
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
        CGPathAddPath(fullRightPath, nil, arrowPath.CGPath)
        CGPathAddPath(fullLeftPath, nil, circlePathLeft.CGPath)
        CGPathAddPath(fullLeftPath, nil, arrowPath.CGPath)
        
        let drawPath = CABasicAnimation(keyPath: "strokeEnd")
        drawPath.fromValue = 0.0
        drawPath.toValue = 1.0
        drawPath.duration = 2.0
        
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
        
        rightButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        leftButton.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        rightShapeLayer.addAnimation(drawPath, forKey: "path Animation")
        leftShapeLayer.addAnimation(drawPath, forKey: "Path Animation")
        rightButtonStrokeLayer = rightShapeLayer
        leftButtonStrokeLayer = leftShapeLayer
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
    
    @IBAction func rightButtonClicked(sender: AnyObject) {
        if currentPage < jsonData.count - 1{
            currentPage += 1
            animateMap()
            updateTextWithNewSlide()
        }
    }
    
    @IBAction func leftButtonClicked(sender: AnyObject) {
        if currentPage > 0{
            currentPage -= 1
            animateMap()
            updateTextWithNewSlide()
        }
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

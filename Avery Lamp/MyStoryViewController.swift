//
//  MyStoryViewController.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/3/16.
//  Copyright © diameter / 216 Avery Lamp. All rights reserved.
//

import UIKit
import MapKit
//import LTMorphingLabel

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
    var firstAnimation = true
    
    let counterLabel = LTMorphingLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupJSON()
        mapView.delegate = self
        
        mapView.mapType = MKMapType.hybridFlyover
        mapView.isPitchEnabled = true
        mapView.showsCompass = false
        let xCoord = jsonData[0]["xCoord"].doubleValue
        let yCoord = jsonData[0]["yCoord"].doubleValue
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(xCoord, yCoord), MKCoordinateSpanMake(0.002, 0.002))
        
        mapView.setRegion(region, animated: true)

        addAnnotations()
        animateMap()
        firstAnimation = false
        
        drawButtons()
        detailImageView.contentMode = .scaleAspectFit
        detailTextLabel.numberOfLines = 0
        detailTextLabel.lineBreakMode = .byWordWrapping
        maxRadius = self.view.frame.width / 2
        detailImageView.image = UIImage(named: jsonData[currentPage]["DetailImage"].string!)
        view.bringSubview(toFront: detailTextLabel)
        loadText(currentPage)
        counterLabel.frame = CGRect(x: 0, y: self.view.frame.height - 35, width: self.view.frame.width, height: 30)
        counterLabel.morphingDuration = 0.8
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont(name: "Panton-Light", size: 20)
        self.view.addSubview(counterLabel)
        counterLabel.text = "1/\(jsonData.count)"
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRecognizer)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AppExploreMoreViewController.handleSwipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRecognizer)
        let firstOpen = UserDefaults.standard.value(forKey: "FirstStoryOpen") as? Bool
        if firstOpen == nil{
            print("First Open")
            instructionsPopup()
            UserDefaults.standard.setValue(false, forKey: "FirstStoryOpen")
        }else if firstOpen == false{
            pageChangeEnabled = true
            print("Not first open")
        }
        setupLineOverlay()
    }
    var introView: UIView?
    
    func instructionsPopup() {
        let popupView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width - 100, height: 400))
        popupView.layer.masksToBounds = true
        introView = popupView
        popupView.layer.cornerRadius = 20
        popupView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        popupView.alpha = 0.0
        self.view.addSubview(popupView)
        popupView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 80)
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
            popupView.center = self.view.center
            popupView.alpha = 1.0
            }, completion: nil)
        
        let helloThereLabel = UILabel(frame: CGRect(x: 0,y: 0,width: popupView.frame.width,height: 50))
        helloThereLabel.text = "Hello There"
        helloThereLabel.font = UIFont(name: "Panton-Semibold", size: 30)
        helloThereLabel.textAlignment = .center
        popupView.addSubview(helloThereLabel)
        helloThereLabel.strokeTextAnimated(0.8, delay: 2.0, duration: 1.0, fade: true)
        
        let welcomeToStoryLabel = UILabel(frame: CGRect(x: 0,y: 55,width: popupView.frame.width, height: 30))
        welcomeToStoryLabel.text = "Welcome to My Story"
        welcomeToStoryLabel.font = UIFont(name: "Panton-Regular", size: 20)
        welcomeToStoryLabel.textAlignment = .center
        popupView.addSubview(welcomeToStoryLabel)
        welcomeToStoryLabel.strokeTextSimultaneously(0.6, delay: 2.5, duration: 1.0, fade: true, returnStuff: false)
        
        let consiseStatement = UILabel(frame: CGRect(x: 20, y: 80, width: popupView.frame.width - 40, height: 150))
        consiseStatement.numberOfLines = 0
        consiseStatement.lineBreakMode = .byWordWrapping
        consiseStatement.text = "I will try to explain my story in as few words as possible, but quite frankly a lot has happened in the past year."
        consiseStatement.font = UIFont(name: "Panton-Regular", size: 20)
        popupView.addSubview(consiseStatement)
        consiseStatement.strokeTextLetterByLetter(0.6, delay: 3.5, duration: 3.0, characterStrokeDuration: 1.0, fade: true, fadeDuration: 0.5, returnStuff: false)
        //MARK - Unfortunately had to take out LTMORPHINGLABEL due to Swift 3 updates and LTMorphing label not working anymore
        let morphingStatement = UILabel(frame: CGRect(x: 20,y: 210,width: popupView.frame.width - 40, height: 60))
        morphingStatement.text = "By a lot, I mean..."
        morphingStatement.textAlignment = .center
//        morphingStatement.font = UIFont(name: "Panton-Regular", size: 20)
        popupView.addSubview(morphingStatement)
//        morphingStatement.morphingEffect = .fall
        morphingStatement.strokeTextLetterByLetter(0.6, delay: 6.0, duration: 1.0, characterStrokeDuration: 0.5, fade: true, fadeDuration: 0.3, returnStuff: false)
        delay(8.0) {
            morphingStatement.frame = CGRect(x: 20, y: 210, width: popupView.frame.width - 40, height: 60)
            UIView.animate(withDuration: 0.2, animations: { 
            })
            UIView.animate(withDuration: 0.3, animations: {
                morphingStatement.alpha = 0.0
                
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        morphingStatement.text = "I mean a tremendous amount"
                        morphingStatement.alpha = 1.0
                    })
            })
        }
        delay(9.5) {
            UIView.animate(withDuration: 0.2, animations: {
            })
            UIView.animate(withDuration: 0.3, animations: {
                morphingStatement.alpha = 0.0
                
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        morphingStatement.text = "Like 2 Internships"
                        morphingStatement.alpha = 1.0
                    })
            })
        }
        delay(11.0) {
            UIView.animate(withDuration: 0.2, animations: {
            })
            UIView.animate(withDuration: 0.3, animations: {
                morphingStatement.alpha = 0.0
                
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        morphingStatement.text = "10 Hackathons"
                        morphingStatement.alpha = 1.0
                    })
            })
        }
        delay(12.5) {
            UIView.animate(withDuration: 0.2, animations: {
            })
            UIView.animate(withDuration: 0.3, animations: {
                morphingStatement.alpha = 0.0
                
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        morphingStatement.text = "4 Years of Fun"
                        morphingStatement.alpha = 1.0
                    })
            })
        }
        delay(14.0) {
            UIView.animate(withDuration: 0.2, animations: {
            })
            UIView.animate(withDuration: 0.3, animations: {
                morphingStatement.alpha = 0.0
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        morphingStatement.text = "With Much More to Come"
                        morphingStatement.alpha = 1.0
                    })
            })
        }
        
        let forceTouchLabel = UILabel(frame: CGRect(x: 20, y: 270, width: popupView.frame.width - 40, height: 80))
        forceTouchLabel.numberOfLines = 0
        forceTouchLabel.lineBreakMode = .byWordWrapping
        forceTouchLabel.text = "To see a picture for each location, force touch the text.\n"
        forceTouchLabel.font = UIFont(name: "Panton-Thin", size: 18)
        popupView.addSubview(forceTouchLabel)
        forceTouchLabel.strokeTextSimultaneously(0.6, delay: 15.5, duration: 1.0, fade: false, returnStuff: false)
        
        let continueButton = UIButton(frame: CGRect(x: 0,y: popupView.frame.height,width: popupView.frame.width, height: 60))
        continueButton.setTitle("Got it, tell me your story.", for: UIControlState())
        continueButton.backgroundColor = UIColor(rgba: "#3eba5e")
        popupView.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(MyStoryViewController.dismissIntro), for: .touchUpInside)
        UIView.animate(withDuration: 1.0, delay: 18.0, options: .curveEaseOut, animations: {
            continueButton.center = CGPoint(x: continueButton.center.x, y: continueButton.center.y - 60)
            }, completion: nil)
        
    }
    
    func dismissIntro() {
        pageChangeEnabled = true
        UIView.animate(withDuration: 1.0, animations: { 
            self.introView?.center = CGPoint(x: self.introView!.center.x, y: self.introView!.center.y - 80)
            self.introView?.alpha = 0.0
            }, completion: { (finished) in
                self.introView?.removeFromSuperview()
        }) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    var camerasArray = [MKMapCamera]()
    
    
    func flyToLocation (_ location: CLLocationCoordinate2D, finalPitchCamera: MKMapCamera? = nil, flyoverAltitude:Double = 50, finalAltitude: Double = 100){
        let startCoord = self.mapView.camera.centerCoordinate
        let eyeCoord = CLLocationCoordinate2DMake(location.latitude, location.longitude)
//        let upCam = MKMapCamera(lookingAtCenterCoordinate: startCoord, fromEyeCoordinate: startCoord, eyeAltitude: flyoverAltitude)
        print("Flyover Altitude \(flyoverAltitude)")
        let turnCam = MKMapCamera(lookingAtCenter: location, fromEyeCoordinate: startCoord, eyeAltitude: flyoverAltitude)
//        let inCam = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude)
        if finalPitchCamera != nil{
            let inCam = MKMapCamera(lookingAtCenter: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude * 2)
            camerasArray = [turnCam, inCam,finalPitchCamera!]
        }else{
            let inCam = MKMapCamera(lookingAtCenter: location, fromEyeCoordinate: eyeCoord, eyeAltitude: finalAltitude)
            camerasArray = [turnCam, inCam]
        }
        goToNextCamera()
    }
    
    func goToNextCamera() {
        if camerasArray.count == 0{
            return
        }
        let nextCam = self.camerasArray.first
        self.camerasArray.remove(at: 0)
        UIView.animate(withDuration: 2.0, animations: {
            self.mapView.camera = nextCam!
        }) 
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       goToNextCamera()
    }
    
    var annotationPins = [MKPointAnnotation]()
    
    func addAnnotations(){
        annotationPins = [MKPointAnnotation]()
        for index in 0..<jsonData.count{
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(jsonData[index]["xCoord"].doubleValue, jsonData[index]["yCoord"].doubleValue)
            pointAnnotation.title = jsonData[index]["DetailTitle"].string
            pointAnnotation.subtitle = jsonData[index]["DetailSubtitle"].string
            mapView.addAnnotation(pointAnnotation)
            annotationPins.append(pointAnnotation)
        }
    }
    
    func setupJSON(){
        if let path = Bundle.main.path(forResource: "StoryData", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
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
    
    func loadText(_ index:Int)  {
        //        detailTextLabel.layer.superlayer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        detailTextLabel.text = jsonData[index]["DetailText"].string
        detailTextLabel.layoutIfNeeded()
        
        labelStrokes = detailTextLabel.strokeTextLetterByLetter(0.6, delay: 0.0, duration: 3.0, characterStrokeDuration: 1.0, fade: false, fadeDuration: 0.3, returnStuff: true)
//        labelStrokes.forEach { $0.anchorPoint = CGPointMake(0.5, 0.5)}
    }
    
    func updateTextWithNewSlide(){
        let reverseStroke = CABasicAnimation(keyPath: "strokeEnd")
        reverseStroke.duration = 2.0
        reverseStroke.fromValue = 1.0
        reverseStroke.toValue = 0.0
        reverseStroke.fillMode = kCAFillModeForwards
        reverseStroke.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        CATransaction.setCompletionBlock({
            self.detailTextLabel.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            self.labelStrokes.forEach { $0.removeFromSuperlayer() }
            self.labelStrokes = [CAShapeLayer]()
            self.loadText(self.currentPage)
        })
        
        labelStrokes.forEach { $0.strokeEnd = 0 }
        
        CATransaction.commit()
        counterLabel.text = "\(currentPage + 1)/\(jsonData.count)"
        detailImageView.alpha = 0.0
        detailImageView.image = UIImage(named: jsonData[currentPage]["DetailImage"].string!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.location(in: self.view)
        if detailTextLabel.frame.contains(locationInText){
            animateLabelWithTouch(touch, location: locationInText)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.location(in: self.view)
        if detailTextLabel.frame.contains(locationInText){
            animateLabelWithTouch(touch, location: locationInText)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let locationInText = touch.location(in: self.view)
        
        animateLabelWithTouch(touch, location: locationInText,ended: true)
        
    }
    
    var maxRadius:CGFloat = 200.0
    var transitioningBetweenSlides = false
    func animateLabelWithTouch(_ touch:UITouch, location: CGPoint, ended: Bool = false){
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
        let fullRightPath = CGMutablePath()
        let fullLeftPath = CGMutablePath()
        let circlePathRight = UIBezierPath(arcCenter: CGPoint(x: diameter / 2, y: diameter / 2), radius: diameter / 2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2 + M_PI * 2), clockwise: true)
        let circlePathLeft = UIBezierPath(arcCenter: CGPoint(x: diameter / 2, y: diameter / 2), radius: diameter / 2, startAngle: CGFloat(M_PI_2 + M_PI * 2), endAngle: CGFloat(M_PI_2), clockwise: false)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: diameter / 2, y: diameter))
        arrowPath.addLine(to: CGPoint(x: diameter / 2, y: diameter / 4))
        arrowPath.addLine(to: CGPoint(x: diameter * 3 / 4, y: diameter * 5 / 8))
        arrowPath.move(to: CGPoint(x: diameter / 2, y: diameter / 4))
        arrowPath.addLine(to: CGPoint(x: diameter / 4, y: diameter * 5 / 8))
        
        fullRightPath.addPath(circlePathRight.cgPath)
//        CGPathAddPath(fullRightPath, nil, circlePathRight.cgPath)
//        CGPathAddPath(fullRightPath, nil, arrowPath.CGPath)
        fullRightPath.addPath(circlePathLeft.cgPath)
//        CGPathAddPath(fullLeftPath, nil, circlePathLeft.cgPath)
//        CGPathAddPath(fullLeftPath, nil, arrowPath.CGPath)
        
        let drawPath = CABasicAnimation(keyPath: "strokeEnd")
        drawPath.fromValue = 0.0
        drawPath.toValue = 1.0
        drawPath.duration = 2.0
        let rightArrowShape = CAShapeLayer()
        rightArrowShape.path = arrowPath.cgPath
        rightArrowShape.fillColor = nil
        rightArrowShape.lineWidth = 1.0
        rightArrowShape.strokeColor = UIColor.black.cgColor
        let leftArrowShape = CAShapeLayer()
        leftArrowShape.path = arrowPath.cgPath
        leftArrowShape.fillColor = nil
        leftArrowShape.lineWidth = 1.0
        leftArrowShape.strokeColor = UIColor.black.cgColor
        
        let rightShapeLayer = CAShapeLayer()
        rightShapeLayer.path = fullRightPath
        rightShapeLayer.fillColor = nil
        rightShapeLayer.lineWidth = 1.0
        rightShapeLayer.strokeColor = UIColor.black.cgColor
        let leftShapeLayer = CAShapeLayer()
        leftShapeLayer.path = fullLeftPath
        leftShapeLayer.fillColor = nil
        leftShapeLayer.lineWidth = 1.0
        leftShapeLayer.strokeColor = UIColor.black.cgColor
        rightButton.layer.addSublayer(rightShapeLayer)
        leftButton.layer.addSublayer(leftShapeLayer)
        rightButton.layer.addSublayer(rightArrowShape)
        leftButton.layer.addSublayer(leftArrowShape)
        
        rightButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        leftButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        
        rightShapeLayer.add(drawPath, forKey: "path Animation")
        leftShapeLayer.add(drawPath, forKey: "Path Animation")
        rightArrowShape.add(drawPath, forKey: "path Animation")
        leftArrowShape.add(drawPath, forKey: "Path Animation")
        rightButtonArrowLayer = rightArrowShape
        leftButtonArrowLayer = leftArrowShape
    }
    
    func plusOnePath(_ right:Bool) -> CGPath{
        let width = rightButton.frame.width
        let plusOnePath = UIBezierPath()
        plusOnePath.move(to: CGPoint(x: 0, y: width / 2))
        plusOnePath.addLine(to: CGPoint(x: width / 3,  y: width / 2))
        plusOnePath.move(to: CGPoint(x: width / 6, y: width / 3))
        plusOnePath.addLine(to: CGPoint(x: width / 6, y: width * 2 / 3))
        plusOnePath.move(to: CGPoint(x: 0.6 * width, y: 0.2 * width))
        plusOnePath.addLine(to: CGPoint(x: 0.75 * width, y: 0.1 * width))
        plusOnePath.addLine(to: CGPoint(x: 0.75 * width, y: 0.8 * width))
        plusOnePath.move(to: CGPoint(x: 0.5 * width, y: 0.8 * width))
        plusOnePath.addLine(to: CGPoint(x: width, y: 0.8 * width))
        
        let bounds = plusOnePath.cgPath.boundingBox
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        plusOnePath.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
        if right{
            plusOnePath.apply(CGAffineTransform(rotationAngle: CGFloat(-M_PI_2)))
        }else{
            plusOnePath.apply(CGAffineTransform(rotationAngle: CGFloat(M_PI_2)))
        }
        plusOnePath.apply(CGAffineTransform(translationX: center.x, y: center.y))
        return plusOnePath.cgPath
    }
    
    func animateMap(){
        for i in 0..<mapView.annotations.count{
            self.mapView.deselectAnnotation(annotationPins[i], animated: true)
        }
        self.mapView.selectAnnotation(annotationPins[currentPage], animated: true)
        if firstAnimation == true{
            return
        }
        
        let nextLocation = CLLocationCoordinate2DMake(jsonData[currentPage]["xCoord"].doubleValue,jsonData[currentPage]["yCoord"].doubleValue )
        if jsonData[currentPage]["cam"] != nil {
            let camData = jsonData[currentPage]["cam"]
            let pitchCam = MKMapCamera(lookingAtCenter: nextLocation, fromEyeCoordinate: CLLocationCoordinate2DMake(camData["xCoord"].doubleValue, camData["yCoord"].doubleValue), eyeAltitude: camData["altitude"].doubleValue)
            pitchCam.pitch = CGFloat(camData["pitch"].doubleValue)
            var flyAltitude = jsonData[currentPage]["flyoverAltitude"].doubleValue
            if flyAltitude == 0{
                flyAltitude = 50
            }
            flyToLocation(nextLocation, finalPitchCamera: pitchCam , flyoverAltitude: flyAltitude, finalAltitude: camData["altitude"].doubleValue)
        }else{
            var flyAltitude = jsonData[currentPage]["flyoverAltitude"].doubleValue
            if flyAltitude == 0{
                flyAltitude = 1000.0
            }
            flyToLocation(nextLocation, finalPitchCamera: nil, flyoverAltitude: flyAltitude , finalAltitude: 80)
        }
        
    }
    
    
    func handleSwipe(_ gesture:UISwipeGestureRecognizer){
        if(gesture.direction == UISwipeGestureRecognizerDirection.left){
            rightButtonClicked(UIView())
        }
        if(gesture.direction == UISwipeGestureRecognizerDirection.right){
            leftButtonClicked(UIView())
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: AnyObject) {
        if pageChangeEnabled == false{
            return
        }
        if currentPage < jsonData.count - 1{
            currentPage += 1
            animateMap()
            updateTextWithNewSlide()
            
            rightButtonArrowLayer?.removeAllAnimations()
            rightButtonArrowLayer?.position = CGPoint(x: 0, y: 0)
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.rightButtonArrowLayer?.position = CGPoint(x: 0, y: 0)
                CATransaction.begin()
                self.rightButtonArrowLayer?.opacity = 1.0
                CATransaction.commit()
            })
            CATransaction.setAnimationDuration(1.0)
            
            rightButtonArrowLayer?.position = CGPoint(x: rightButtonArrowLayer!.position.x, y: rightButtonArrowLayer!.position.y - 20)
            rightButtonArrowLayer?.opacity = 0.0
            CATransaction.commit()
        }
        
    }
    
    @IBAction func leftButtonClicked(_ sender: AnyObject) {
        if pageChangeEnabled == false{
            return
        }
        if currentPage > 0{
            currentPage -= 1
            animateMap()
            updateTextWithNewSlide()
            
            leftButtonArrowLayer?.removeAllAnimations()
            leftButtonArrowLayer?.position = CGPoint(x: 0, y: 0)
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.leftButtonArrowLayer?.position = CGPoint(x: 0, y: 0)
                CATransaction.begin()
                self.leftButtonArrowLayer?.opacity = 1.0
                CATransaction.commit()
            })
            CATransaction.setAnimationDuration(1.0)
            
            leftButtonArrowLayer?.position = CGPoint(x: leftButtonArrowLayer!.position.x, y: leftButtonArrowLayer!.position.y - 20)
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
        mapView.add(routeLine!)
    }

    var routeLine: MKPolyline? = nil
    var routeLineView:MKPolylineView? = nil
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
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
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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

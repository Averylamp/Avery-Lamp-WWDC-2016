//
//  AppDelegate.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 1/28/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

enum DGShortcutItemType: String {
    case Introduction
    case Home
    case MyStory
    case MyInfo
    case MyApps
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let last = shortcutItem.type.componentsSeparatedByString(".").last else { return nil }
        self.init(rawValue: last)
    }
    
    var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            handleShortcutItem(shortcutItem)
        }
        
        return true
    }
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
    }
    
    
    
    private func handleShortcutItem(shortcutItem:UIApplicationShortcutItem){
        if let rootViewController = window?.rootViewController as? UINavigationController, let shortcutItemType = DGShortcutItemType(shortcutItem: shortcutItem) {
            rootViewController.dismissViewControllerAnimated(false, completion: nil)
//            let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
            
            switch shortcutItemType {
            case .Introduction:
                rootViewController.viewControllers = [SplashViewController()]
//                alertController.message = "It's time to search"
                break
            case .Home:
                rootViewController.pushViewController(HomeViewController(), animated: false)
//                alertController.message = "Show me my favorites"
                break
            case .MyInfo:
                rootViewController.pushViewController(HomeViewController(), animated: false)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myStoryTVC = storyboard.instantiateViewControllerWithIdentifier("MyInfoVC")
                rootViewController.pushViewController(myStoryTVC, animated: false)
//                alertController.message = "Show me my favorites"
                break
            case .MyStory:
//                rootViewController.viewControllers = [HomeViewController(),MyStoryViewController()]
                rootViewController.pushViewController(HomeViewController(), animated: false)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myStoryTVC = storyboard.instantiateViewControllerWithIdentifier("MyStoryVC")
                rootViewController.pushViewController(myStoryTVC, animated: false)
                
//                rootViewController.pushViewController(MyStoryViewController(), animated: false)
//                alertController.message = "Show me my favorites"
                break
            case .MyApps:
                rootViewController.pushViewController(HomeViewController(), animated: false)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myStoryTVC = storyboard.instantiateViewControllerWithIdentifier("MyAppsTVC")
                rootViewController.pushViewController(myStoryTVC, animated: false)
//                alertController.message = "Show me my favorites"
                break
            }
            
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            rootViewController.presentViewController(alertController, animated: true, completion: nil)
        }

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


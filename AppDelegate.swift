//
//  AppDelegate.swift
//  NoFear
//
//  Created by Gururaj Tallur on 29/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

/*

Gamecenter
facebook,Twitter,Email,SMS

inAP Purchase

Ads

*/

import Foundation


@UIApplicationMain class AppDelegate : CCAppDelegate,UIApplicationDelegate {

    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

       // CCBReader.configureCCFileUtils()
        
        
        var configPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("Published-iOS")
        configPath = configPath?.stringByAppendingPathComponent("configCocos2d.plist")
        var cocos2dSetup = NSDictionary(contentsOfFile: configPath!)
        self.setupCocos2dWithOptions(cocos2dSetup! as Dictionary)
        

        return true
    }
    
    override func startScene() -> (CCScene) {
        return MainScene()
    }
}
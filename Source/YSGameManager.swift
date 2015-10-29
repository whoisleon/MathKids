//
//  YSGameManager.swift
//  NoFear
//
//  Created by Gururaj Tallur on 22/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import Social
import MessageUI

let isPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad

let IS_IPHONE5 = fabs(UIScreen.mainScreen().bounds.size.height-568) < 1;
let isRetina = UIScreen.mainScreen().respondsToSelector("displayLinkWithTarget:selector:") && UIScreen.mainScreen().scale == 2

let FONT_GAME_UI_LBL = "AvenirNext-Bold" as String





private let _sharedGameManager = YSGameManager();

enum Game_Mode
{
    case kGameMode_KidsMode
    case kGameMode_NormalMode
    case kGameMode_ExpertMode
}


enum GameScreen
{
    case kSceneFlashScreen
    case kSceneMainMenu
    case kSceneGameScreen
    case kSceneStoreScreen
    case kSceneGameOver
}

enum Operators
{
    case kOperator_Plus
    case kOperator_Minus
    case kOperator_Multiplication
    case kOperator_Division
}


class YSGameManager: NSObject, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    var gGameMode:Game_Mode?
    var currentLevel:Int = 0
    var maxLevel:Int = 0
    var levelScore:Int = 0

    var highScore_Normal:Int = 0
    var highScore_Kids:Int = 0
    var highScore_Expert:Int = 0

    class var sharedGameManager : YSGameManager {
        return _sharedGameManager;
    }
    
    override init()
    {
        super.init()
        
        loadPreference()
    }
    
    func savePreference()
    {
        NSUserDefaults.standardUserDefaults().setInteger(self.highScore_Normal, forKey: "highScore_Normal")
        NSUserDefaults.standardUserDefaults().setInteger(self.highScore_Kids, forKey: "highScore_Kids")
        NSUserDefaults.standardUserDefaults().setInteger(self.highScore_Expert, forKey: "highScore_Expert")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadPreference()
    {
        if((NSUserDefaults.standardUserDefaults().objectForKey("isKidsModeUnlocked"))==nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isKidsModeUnlocked")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if((NSUserDefaults.standardUserDefaults().objectForKey("isExpertModeUnlocked"))==nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isExpertModeUnlocked")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        
        self.highScore_Normal = NSUserDefaults.standardUserDefaults().integerForKey("highScore_Normal")
        self.highScore_Kids = NSUserDefaults.standardUserDefaults().integerForKey("highScore_Kids")
        self.highScore_Expert = NSUserDefaults.standardUserDefaults().integerForKey("highScore_Expert")
    }
    
    /*
    func i5res(inString:String)->String
    {
        if IS_IPHONE5
        {
            return inString.stringByReplacingOccurrencesOfString(".", withString: "-iphone5hd.")
        }
        else if isPad
        {
            if isRetina
            {
                return inString.stringByReplacingOccurrencesOfString(".", withString: "-ipadhd.")
            }
            else
            {
                return inString.stringByReplacingOccurrencesOfString(".", withString: "-ipad.")
            }
        }
        else
        {
            if isRetina
            {
                return inString.stringByReplacingOccurrencesOfString(".", withString: "-hd.")
            }
        }
        
        return inString;
    }*/
    
    func replaceGameScene(inScreen: GameScreen)
    {
        switch inScreen
        {
            case GameScreen.kSceneGameScreen:
                CCDirector.sharedDirector().replaceScene(YSGameScene.scene())
                break
            case GameScreen.kSceneMainMenu :
                CCDirector.sharedDirector().replaceScene(MainScene.scene())
                break
        default:
                break
        }
    }
    
    func facebookBtnPress(inImage:UIImage)
    {
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText("Checkout Ultimate iPhone Game : \(kGameName).")
        shareToFacebook.addURL(NSURL(string: kGameLink))
        shareToFacebook.addImage(inImage)
        CCDirector.sharedDirector().presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    func twitterBtnPress(inImage:UIImage)
    {
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareToFacebook.setInitialText("Checkout Ultimate iPhone Game : \(kGameName).")
        shareToFacebook.addURL(NSURL(string: kGameLink))
        shareToFacebook.addImage(inImage)
        CCDirector.sharedDirector().presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    func emailBtnPress(inImage:UIImage)
    {
        if(MFMailComposeViewController.canSendMail())
        {
            var email = MFMailComposeViewController()
            email.addAttachmentData(UIImagePNGRepresentation(inImage)!, mimeType: "image/png", fileName: "image.png")
            email.mailComposeDelegate = self;
            
            email.setSubject("Checkout Ultimate iPhone Game : \(kGameName).")
            email.setMessageBody("<html><body>I have played this ultimate iphone game. Its awesome!<br><br><br>Download: <a href=\"\(kGameLink)\">\(kGameName)</a><br></body></html>", isHTML: true)
            
           CCDirector.sharedDirector().presentViewController(email, animated:true, completion:nil)


        }
        else
        {
            var alert = UIAlertView(title: "Email not Setup!", message: "Ooops! No email account setup in this device.", delegate: nil, cancelButtonTitle: "Ok")
                    
            alert.show()
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func smsBtnPress()
    {
        let controller = MFMessageComposeViewController()
        
        if(MFMessageComposeViewController.canSendText())
        {
            controller.body = "Hey, I have played top iPhone game - \(kGameName), Its awesome! Try - \(kGameLink)"
            controller.messageComposeDelegate = self
            CCDirector.sharedDirector().presentViewController(controller, animated:true, completion:nil)

        }
        else
        {
            let alert = UIAlertView(title: "Messaging not Supported!", message: "Ooops! This device not support messaging.", delegate: nil, cancelButtonTitle: "Ok")
            
            alert.show()
        }
    }
    
     func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult)
     {
        controller.dismissViewControllerAnimated(true, completion: nil)
     }

}



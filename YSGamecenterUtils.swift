//
//  YSGamecenterUtils.swift
//  NoFear
//
//  Created by Gururaj Tallur on 29/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

import GameKit
private let _sharedGamecenterUtils = YSGamecenterUtils()

class YSGamecenterUtils : NSObject, GKGameCenterControllerDelegate {
    
    class var sharedGamecenterUtils : YSGamecenterUtils{
        return _sharedGamecenterUtils
    }
    
    override init(){
    }
    
    func authenticateLocalUserOnViewController(viewController:UIViewController){
        var localPlayer:GKLocalPlayer = GKLocalPlayer.localPlayer()
        if (localPlayer.authenticated == false) {
            localPlayer.authenticateHandler = {(authViewController, error) -> Void in
                if (authViewController != nil) {
                    viewController.presentViewController(authViewController!,animated:false,completion: nil)
                }
            }
        }
        else {
            print("Already authenticated")
        }
    }
    func reportScore(score:Int,leaderboardID:NSString) {
        let scoreReporter:GKScore = GKScore(leaderboardIdentifier:leaderboardID as String)
        scoreReporter.value = Int64(score)
        scoreReporter.context = 0
        GKScore.reportScores([scoreReporter],withCompletionHandler: {(error) -> Void in
            if let reportError = error {
                print("Unable to report score!\nError:\(error)")
            }
            else {
                print("Score reported successfully!")
            }
        })
    }
    func showLeaderboardOnViewController(viewController:UIViewController?, leaderboardID:NSString){
        if let containerController = viewController {
            let gamecenterController:GKGameCenterViewController = GKGameCenterViewController()
            gamecenterController.gameCenterDelegate = self
            gamecenterController.viewState = GKGameCenterViewControllerState.Leaderboards
            gamecenterController.leaderboardIdentifier = leaderboardID as String
            viewController?.presentViewController(gamecenterController,animated:false,completion: nil)
        }
    }
    func gameCenterViewControllerDidFinish(_gameCenterViewController: GKGameCenterViewController){
        _gameCenterViewController.dismissViewControllerAnimated(false,completion: nil)
    }
    
    func reportAchievements(achId:NSString, perecent:Double)
    {
        let achievement = GKAchievement(identifier: achId as String)
        achievement.showsCompletionBanner = true
        achievement.percentComplete = perecent
        
        GKAchievement.reportAchievements([achievement], withCompletionHandler: nil)
    }
    
    func reportAchievementsF(achId:NSString, perecent:Double)
    {
        let achievement = GKAchievement(identifier: achId as String)
        achievement.showsCompletionBanner = false
        achievement.percentComplete = perecent
        
        GKAchievement.reportAchievements([achievement], withCompletionHandler: nil)
    }
    
}
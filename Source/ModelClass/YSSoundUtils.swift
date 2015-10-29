//
//  YSSoundUtils.swift
//  NoFear
//
//  Created by Gururaj Tallur on 09/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

private let _sharedSoundUtils = YSSoundUtils();

class YSSoundUtils: NSObject {

    class var sharedSoundUtils : YSSoundUtils{
        return _sharedSoundUtils;
    }
    
    func preloadSFX()
    {
        OALSimpleAudio.sharedInstance().preloadEffect("buttonTap1.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("wrong.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("Correct_1.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("Correct_2.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("glassBreak.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("gameOver.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("buttonUp_1.caf");
        OALSimpleAudio.sharedInstance().preloadEffect("buttonUp_2.caf");
    }
    
    func playCorrectPressSFX()
    {
        if(arc4random_uniform(2)==0)
        {
            OALSimpleAudio.sharedInstance().playEffect("Correct_1.caf")
        }
        else
        {
            OALSimpleAudio.sharedInstance().playEffect("Correct_2.caf")
        }

    }
    
    func playButtonUp2SFX()
    {
        OALSimpleAudio.sharedInstance().playEffect("buttonUp_1.caf")
    }
    
    func playButtonTapSFX()
    {
        OALSimpleAudio.sharedInstance().playEffect("buttonTap1.caf")
    }

    func playBackgroundMusic()
    {
        OALSimpleAudio.sharedInstance().playBg("CQ_Music_2.m4a")
    }
    
    func playEndWarnSFX()
    {
        OALSimpleAudio.sharedInstance().playEffect("glassBreak.caf")
    }
    
    func playGameOverSFX()
    {
        OALSimpleAudio.sharedInstance().playEffect("gameOver.caf")
    }
    
}
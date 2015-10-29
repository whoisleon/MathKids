//
//  YSGameScene.swift
//  NoFear
//
//  Created by Gururaj Tallur on 22/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
 

class YSGameScene: CCScene {
    
    var mMaths = YSMaths()

    var mProgressBgNode: CCNode!
    var mLevelTile: CCSprite!

    var mLevelNumber : CCLabelTTF!

    var mLabel_Input1 : CCLabelTTF!
    var mLabel_Input2 : CCLabelTTF!
    var mLabel_Operator : CCLabelTTF!
    var mLabel_Result : CCLabelTTF!
    
    var mOperatorNode: CCNode!
    
    var mInput_Tile_1: CCSprite!
    var mInput_Tile_2: CCSprite!
    var mOperator_Tile: CCSprite!
    var mResult_Tile: CCSprite!
    
    var mEmiter: CCParticleSystem!

    var mProgressBar: CCProgressNode!

    var mIsGameStarted : Bool = false
    
    var mKeyboard_Count: Int = 0
    var mKeyboard_Input: Int = 0
    var mResultImage : UIImage?
    
    var mNumTiles = [CCButton]()
        
    class func scene() -> YSGameScene
    {
        return YSGameScene()
    }
    
    override init()
    {
        super.init()
        self.userInteractionEnabled = true
        
        YSGameManager.sharedGameManager.levelScore = 0;
        YSGameManager.sharedGameManager.currentLevel = 1;
        YSGameManager.sharedGameManager.levelScore = 0;
        YSGameManager.sharedGameManager.maxLevel = 0;

        
        YSGameManager.sharedGameManager.currentLevel = 1;
        YSGameManager.sharedGameManager.levelScore = 0;
        
        
        
        mIsGameStarted = false;
                    
        mMaths.initWithScene(self)
        
        setupBackground()
        showTutorial()
        YSSoundUtils.sharedSoundUtils.playBackgroundMusic()
        setupOperators()
        setupParticleSystem()
    
    }
    
    func setupParticleSystem()
    {
        self.mEmiter = CCParticleSystem(totalParticles:70)
        
        self.mEmiter.texture = CCTextureCache.sharedTextureCache().addImage("effect_tex.png")
            
            //[[CCTextureCache sharedTextureCache] addImage: @"effect_tex.png"];
        
        // duration
        self.mEmiter.duration = 3;//CCParticleSystemDurationInfinity;
        
        // Gravity Mode: gravity
        self.mEmiter.gravity = CGPointZero;
        
        // Set "Gravity" mode (default one)
        self.mEmiter.emitterMode = CCParticleSystemMode.Gravity;
        
        // Gravity Mode: speed of particles
        self.mEmiter.speed = 200;
        self.mEmiter.speedVar = 1;
        
        // Gravity Mode: radial
        self.mEmiter.radialAccel = -120;
        self.mEmiter.radialAccelVar = 0;
        
        // Gravity Mode: tagential
        self.mEmiter.tangentialAccel = 30;
        self.mEmiter.tangentialAccelVar = 0;
        
        // angle
        self.mEmiter.angle = 1;
        self.mEmiter.angleVar = 360;
        
        // emitter position
        self.mEmiter.position = mLevelTile.position;
        self.mEmiter.posVar = CGPointZero;
        
        // life of particles
        self.mEmiter.life = 2;
        self.mEmiter.lifeVar = 1;
        
        // spin of particles
        self.mEmiter.startSpin = 0;
        self.mEmiter.startSpinVar = 0;
        self.mEmiter.endSpin = 0;
        self.mEmiter.endSpinVar = 0;
        
        // color of particles
        self.mEmiter.startColor = CCColor(red: 0.5, green: 0.5, blue: 0.5, alpha:1);
        self.mEmiter.startColorVar = CCColor(red: 0.5, green: 0.5, blue: 0.5, alpha:1)
        self.mEmiter.endColor = CCColor(red: 0.1, green: 0.1, blue: 0.1, alpha:0.2)
        self.mEmiter.endColorVar = CCColor(red: 0.1, green: 0.1, blue: 0.1, alpha:0.2)
        
        // size, in pixels
        self.mEmiter.startSize = 80.0
        self.mEmiter.startSizeVar = 40.0
        self.mEmiter.endSize = -1;
        
        // emits per second
        self.mEmiter.emissionRate = 35;
        
        // additive
        self.mEmiter.blendAdditive = true;
        self.addChild(self.mEmiter, z:3)
        self.mEmiter.stopSystem()
    }
    
    func setupBackground()
    {
        let bg = CCSprite(imageNamed:"BG.png")
        bg.position = ccp(SW*0.5, SH*0.5);
        self.addChild(bg, z: 2);
        

        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_ExpertMode)
        {
           let fade1 = CCActionFadeTo.actionWithDuration(0.8, opacity: 0.3) as! CCActionFadeTo
           let fade2 = CCActionFadeTo.actionWithDuration(0.8, opacity: 1.0) as! CCActionFadeTo
            
            let array1:[AnyObject] = [fade1, fade2]
            let seq1 = CCActionSequence.actionWithArray(array1) as! CCActionSequence
            let rep = CCActionRepeatForever.actionWithAction(seq1) as! CCActionRepeatForever
            
            bg.runAction(rep)
        }
        
        mProgressBgNode = CCNode()
        mProgressBgNode.position = ccp(SW*0.3698, SH*0.9004)
        mProgressBgNode.anchorPoint = ccp(0.0, 0.0)
        self.addChild(mProgressBgNode, z:3)
        
        let frame1 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("progressBarBGB.png") as CCSpriteFrame
        let progressBGB = CCSprite.spriteWithSpriteFrame(frame1) as! CCSprite
        progressBGB.position  = ccp(0.0,0.0)
        mProgressBgNode.addChild(progressBGB, z:3)
        
        
        let frame2 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("progressBarBGF.png") as CCSpriteFrame
        let progressBGF = CCSprite.spriteWithSpriteFrame(frame2) as! CCSprite
        progressBGF.position  = ccp(0.0,0.0)
        mProgressBgNode.addChild(progressBGF, z:5)

        
        let progress = CCSprite(imageNamed:"progress.png")
        mProgressBar = CCProgressNode.progressWithSprite(progress) as  CCProgressNode
        mProgressBar.position  =  ccp(SW*0.0013, SH*0.0146);
        mProgressBar.midpoint = ccp(0.0, 0.0);
        mProgressBar.type = CCProgressNodeType.Bar
        mProgressBar.barChangeRate = ccp(1.0, 0.0);
        mProgressBar.percentage = 99.0;
        mProgressBgNode.addChild(mProgressBar, z:4)

        mLevelTile = CCSprite(imageNamed:"Tile_FinalScore.png")
        mLevelTile.position  = ccp(SW*0.8320, SH*0.9023)
        self.addChild(mLevelTile, z:5)
        
        
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 80 : 40 as CGFloat
        
        mLevelNumber = CCLabelTTF(string:"0", fontName:fntName, fontSize: fntSize)
        mLevelNumber.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        mLevelNumber.position = ccp(mLevelTile.contentSize.width*0.5,mLevelTile.contentSize.height*0.6);
        mLevelTile.addChild(mLevelNumber, z:6)
     }

     func showLevelUp()
     {
        let level = NSString(format:"LEVEL %d", YSGameManager.sharedGameManager.currentLevel) as String
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 30 : 15 as CGFloat

        let levelLabel = CCLabelTTF(string:level, fontName:fntName, fontSize: fntSize)
        levelLabel.anchorPoint = ccp(0.5,0.5);
        levelLabel.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        levelLabel.position = ccp(SW*0.2318, SH*0.9180);
        self.addChild(levelLabel, z:6)
        levelLabel.scale = 0.0;
        
        let scale1 = CCActionScaleTo(duration:0.2, scale: 1.0)
        let scale  = CCActionEaseElasticOut(action:scale1)
        let fade   = CCActionFadeOut(duration:1.5)
        let calB = CCActionCallBlock.actionWithBlock({
            levelLabel.stopAllActions()
            levelLabel.removeFromParentAndCleanup(true)
        }) as! CCActionCallBlock
        
        let array1:[AnyObject] = [scale, fade, calB]
        let seq1 = CCActionSequence.actionWithArray(array1) as! CCActionSequence

        levelLabel.runAction(seq1)
     }
    
    func showTutorial()
    {
        let getReadyNode = CCNode()
        getReadyNode.anchorPoint = ccp(0.0,0.0);
        self.addChild(getReadyNode, z:6)
        
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 80 : 40 as CGFloat
        
        let labelGetReady = CCLabelTTF(string:"GET READY", fontName:fntName, fontSize: fntSize)
        labelGetReady.anchorPoint = ccp(0.5,0.5);
        labelGetReady.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        labelGetReady.position = ccp(SW*0.0, SH*0.0);
        
        let labelGetReadyShaddow = CCLabelTTF(string:"GET READY", fontName:fntName, fontSize: fntSize)
        labelGetReadyShaddow.anchorPoint = ccp(0.5,0.5);
        labelGetReadyShaddow.color = CCColor(red: 0.7, green: 0.3, blue: 0.2)
        labelGetReadyShaddow.position = ccp(SW*0.0, SH*0.0);
        labelGetReadyShaddow.opacity = 0.7
        getReadyNode.addChild(labelGetReadyShaddow, z:6)
        getReadyNode.addChild(labelGetReady, z:6)
        labelGetReadyShaddow.scale = 1.05;

        getReadyNode.position = ccp(SW*0.5, SH*0.7520);
        getReadyNode.visible = false;

        let delay1 = CCActionDelay(duration:0.5)

        let calB1 = CCActionCallBlock(block: ({
                        getReadyNode.scale=2.2;
                        getReadyNode.visible = true;
                    }))
        
//        var calB1 = CCActionCallBlock.actionWithBlock({
//            getReadyNode.scale=2.2;
//            getReadyNode.visible = true;
//        }) as! CCActionCallBlock

        let scale = CCActionScaleTo(duration:0.3, scale: 1.0)
        let delay2 = CCActionDelay(duration:0.5)
        
        let calB2 = CCActionCallBlock.actionWithBlock({
            getReadyNode.stopAllActions()
            getReadyNode.removeFromParentAndCleanup(true)
            self.showCountDown(3)
        }) as! CCActionCallBlock
        
        let array1:[AnyObject] = [delay1, calB1, scale,delay2,calB2]
        let seq1 = CCActionSequence(array:array1)
        getReadyNode.runAction(seq1)
    }
    
    
    func showCountDown(index :Int)
    {
        if(index > 0)
        {
            let numLebelNode = CCNode()
            numLebelNode.anchorPoint = ccp(0.0,0.0)
            self.addChild(numLebelNode, z:6)
            
            let fntName:String = "AvenirNext-Bold"
            let fntSize = (isPad) ? 80 : 40 as CGFloat
            let labelString = NSString(format:"%d", index) as String
            
            let numLabel = CCLabelTTF(string:labelString, fontName:fntName, fontSize: fntSize)
            numLabel.anchorPoint = ccp(0.5,0.5);
            numLabel.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
            numLabel.position = ccp(SW*0.0, SH*0.0);
            
            let numLabelShaddow = CCLabelTTF(string:labelString, fontName:fntName, fontSize: fntSize)
            numLabelShaddow.anchorPoint = ccp(0.5,0.5);
            numLabelShaddow.color = CCColor(red: 0.8, green: 0.5, blue: 0.3)
            numLabelShaddow.position = ccp(SW*0.0, SH*0.0);
            numLabelShaddow.scale = 1.05;

            numLebelNode.addChild(numLabelShaddow)
            numLebelNode.addChild(numLabel)
            
            numLebelNode.position = ccp(SW*0.5, SH*0.7520);
            numLebelNode.visible = false;
            
            let calB1 = CCActionCallBlock.actionWithBlock({
                numLebelNode.scale=2.2;
                numLebelNode.visible = true;
                YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
            }) as! CCActionCallBlock
            
 
            
            let scale = CCActionScaleTo(duration: 0.3, scale: 1.0)
            
            let delay2 = CCActionDelay.actionWithDuration(0.5) as! CCActionDelay
            
            let calB2 = CCActionCallBlock.actionWithBlock({
                    numLebelNode.stopAllActions()
                    numLebelNode.removeFromParentAndCleanup(true)
                    self.showCountDown(index-1)
            }) as! CCActionCallBlock
            
            let array1:[AnyObject] = [calB1, scale, delay2,calB2]
            let seq1 = CCActionSequence.actionWithArray(array1) as! CCActionSequence
            
            numLebelNode.runAction(seq1)
        }
        else
        {
            startGame()
        }
    }
    
    func startGame()
    {
        mMaths.setupOperatorMaths()
        self.setupDigitLabels()
        
        let move = CCActionMoveTo(duration:0.3, position: ccp(0.0,0.0))
        let calBck  = CCActionCallBlock.actionWithBlock({
            self.playGameLevel()
        }) as! CCActionCallBlock
        
        let array1: [AnyObject] = [move, calBck]
        
        let seq  = CCActionSequence(array:array1)
        
        self.mOperatorNode.stopAllActions()
        self.mOperatorNode.runAction(seq)
    }
    
    func setupOperators()
    {
        mOperatorNode = CCNode()
        mOperatorNode.anchorPoint = ccp(0.0,0.0)
        self.addChild(mOperatorNode, z:5)
        mOperatorNode.position = ccp(SW,0.0);
        
        mInput_Tile_1 = CCSprite(imageNamed:"Tile_Operator.png")
        mInput_Tile_1.position  = ccp(SW*0.2, SH*0.7422);
        mOperatorNode.addChild(mInput_Tile_1, z:5)
        
        mInput_Tile_2 = CCSprite(imageNamed:"Tile_Operator.png")
        mInput_Tile_2.position  = ccp(SW*0.6, SH*0.7422);
        mOperatorNode.addChild(mInput_Tile_2, z:5)
        
        mOperator_Tile = CCSprite(imageNamed:"Tile_Operator_3.png")
        mOperator_Tile.position  = ccp(SW*0.4, SH*0.7422);
        mOperatorNode.addChild(mOperator_Tile, z:5)
        
        
        mResult_Tile = CCSprite(imageNamed:"Tile_Operator.png")
        mResult_Tile.position  = ccp(SW*0.8, SH*0.7422);
        mOperatorNode.addChild(mResult_Tile, z:5)
        
        
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 65 : 28 as CGFloat
        
//        mLabel_Input1 = CCLabelTTF.labelWithString("5", fontName:fntName, fontSize: fntSize) as CCLabelTTF
        
        mLabel_Input1 = CCLabelTTF(string:"5", fontName:fntName, fontSize: fntSize)
        mLabel_Input1.color = CCColor(red: 0.5, green: 0.5, blue: 0.5)
        mLabel_Input1.position = ccp(SW*0.2, SH*0.7539)
        mLabel_Input1.anchorPoint = ccp(0.5, 0.5)
        mOperatorNode.addChild(mLabel_Input1, z:5)
        
        mLabel_Input2 = CCLabelTTF(string:"6", fontName:fntName, fontSize: fntSize)
        mLabel_Input2.color = CCColor(red: 0.5, green: 0.5, blue: 0.5)
        mLabel_Input2.position = ccp(SW*0.6, SH*0.7539)
        mLabel_Input2.anchorPoint = ccp(0.5, 0.5)
        mOperatorNode.addChild(mLabel_Input2, z:5)
        
        mLabel_Operator = CCLabelTTF(string:"+", fontName:fntName, fontSize: fntSize)
        mLabel_Operator.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        mLabel_Operator.position = ccp(SW*0.4, SH*0.7539)
        mLabel_Operator.anchorPoint = ccp(0.5, 0.5)
        mOperatorNode.addChild(mLabel_Operator, z:5)
        
        mLabel_Result = CCLabelTTF(string:"=?", fontName:fntName, fontSize: fntSize)
        mLabel_Result.color = CCColor(red: 0.5, green: 0.5, blue: 0.5)
        mLabel_Result.position = ccp(SW*0.8, SH*0.7539)
        mLabel_Result.anchorPoint = ccp(0.5, 0.5)
        mOperatorNode.addChild(mLabel_Result, z:5)
        
        
        let frame01 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_0.png") as CCSpriteFrame
        let frame02 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_0.png") as CCSpriteFrame
        let frame03 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_0.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame01, highlightedSpriteFrame:frame02, disabledSpriteFrame: frame03) )
        mNumTiles[0].setTarget(self, selector: Selector("tileBtn_0_Press"))
        mNumTiles[0].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[0], z:5)
        
        
        let frame11 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_1.png") as CCSpriteFrame
        let frame12 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_1.png") as CCSpriteFrame
        let frame13 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_1.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame11, highlightedSpriteFrame:frame12, disabledSpriteFrame: frame13) )
        
        mNumTiles[1].setTarget(self, selector: Selector("tileBtn_1_Press"))
        mNumTiles[1].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[1], z:5)
        
        let frame21 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_2.png") as CCSpriteFrame
        let frame22 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_2.png") as CCSpriteFrame
        let frame23 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_2.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame21, highlightedSpriteFrame:frame22, disabledSpriteFrame: frame23) )
        mNumTiles[2].setTarget(self, selector: Selector("tileBtn_2_Press"))
        mNumTiles[2].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[2], z:5)
        
        let frame31 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_3.png") as CCSpriteFrame
        let frame32 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_3.png") as CCSpriteFrame
        let frame33 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_3.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame31, highlightedSpriteFrame:frame32, disabledSpriteFrame: frame33) )

        mNumTiles[3].setTarget(self, selector: Selector("tileBtn_3_Press"))
        mNumTiles[3].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[3], z:5)
        
        let frame41 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_4.png") as CCSpriteFrame
        let frame42 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_4.png") as CCSpriteFrame
        let frame43 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_4.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame41, highlightedSpriteFrame:frame42, disabledSpriteFrame: frame43) )
        mNumTiles[4].setTarget(self, selector: Selector("tileBtn_4_Press"))
        mNumTiles[4].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[4], z:5)
        
        let frame51 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_5.png") as CCSpriteFrame
        let frame52 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_5.png") as CCSpriteFrame
        let frame53 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_5.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame51, highlightedSpriteFrame:frame52, disabledSpriteFrame: frame53) )
        mNumTiles[5].setTarget(self, selector: Selector("tileBtn_5_Press"))
        mNumTiles[5].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[5], z:5)
        
        let frame61 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_6.png") as CCSpriteFrame
        let frame62 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_6.png") as CCSpriteFrame
        let frame63 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_6.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame61, highlightedSpriteFrame:frame62, disabledSpriteFrame: frame63) )
        mNumTiles[6].setTarget(self, selector: Selector("tileBtn_6_Press"))
        mNumTiles[6].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[6], z:5)
        
        let frame71 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_7.png") as CCSpriteFrame
        let frame72 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_7.png") as CCSpriteFrame
        let frame73 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_7.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame71, highlightedSpriteFrame:frame72, disabledSpriteFrame: frame73) )
        mNumTiles[7].setTarget(self, selector: Selector("tileBtn_7_Press"))
        mNumTiles[7].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[7], z:5)
        
        let frame81 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_8.png") as CCSpriteFrame
        let frame82 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_8.png") as CCSpriteFrame
        let frame83 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_8.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame81, highlightedSpriteFrame:frame82, disabledSpriteFrame: frame83) )
        mNumTiles[8].setTarget(self, selector: Selector("tileBtn_8_Press"))
        mNumTiles[8].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[8], z:5)
        
        let frame91 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_9.png") as CCSpriteFrame
        let frame92 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_9.png") as CCSpriteFrame
        let frame93 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("num_9.png") as CCSpriteFrame
        
        mNumTiles.append(CCButton(title:"", spriteFrame: frame91, highlightedSpriteFrame:frame92, disabledSpriteFrame: frame93) )
        mNumTiles[9].setTarget(self, selector: Selector("tileBtn_9_Press"))
        mNumTiles[9].zoomWhenHighlighted = true;
        self.addChild(mNumTiles[9], z:5)
        
        
        mNumTiles[1].position = ccp(SW*0.3, SH*0.59) ;
        mNumTiles[2].position = ccp(SW*0.5, SH*0.59) ;
        mNumTiles[3].position = ccp(SW*0.7, SH*0.59) ;
        mNumTiles[4].position = ccp(SW*0.3, SH*0.45) ;
        mNumTiles[5].position = ccp(SW*0.5, SH*0.45) ;
        mNumTiles[6].position = ccp(SW*0.7, SH*0.45) ;
        
        mNumTiles[7].position = ccp(SW*0.3, SH*0.31) ;
        mNumTiles[8].position = ccp(SW*0.5, SH*0.31) ;
        mNumTiles[9].position = ccp(SW*0.7, SH*0.31) ;
        mNumTiles[0].position = ccp(SW*0.5, SH*0.17) ;
        
        for i in 0...9
        {
            mNumTiles[i].enabled = false;
        }
    }
    
    func setupDigitLabels()
    {
        mLabel_Input1.string = NSString(format:"%d", mMaths.input_1) as String
        mLabel_Input2.string = NSString(format:"%d", mMaths.input_2) as String

        let result_String = "=" as String
        
        var i=0
        for i in 0..<mMaths.result_Digit_Count
        {
            result_String.stringByAppendingString("?")
        }
        
        if(mMaths.result_Digit_Count > 2)
        {
            mLabel_Result.fontSize = (isPad) ? 50 : 18 ;
        }
        else
        {
            mLabel_Result.fontSize = (isPad) ? 65 : 28 ;
        }
        
        mLabel_Result.string = result_String
        
        let op = mMaths.currentOp as Operators
        
        switch (op)
        {
            case Operators.kOperator_Plus:
                    mLabel_Operator.string = "+"
                    break;
            case Operators.kOperator_Minus:
                    mLabel_Operator.string = "-"
                    break;
            case Operators.kOperator_Division:
                    mLabel_Operator.string = "/"
                    break;
            case Operators.kOperator_Multiplication:
                    mLabel_Operator.string = "X"
                    break;
            
        default:
            break;
        }
    }
    
    func playGameLevel()
    {
        mIsGameStarted = true;
        
        mKeyboard_Count = 0;
        
        mKeyboard_Input = 0;
        
        mProgressBar.percentage = 99;
        
        mProgressBar.stopAllActions()
        
        let duration1 = self.getProgressDuration() as Double
  
        let progres = CCActionProgressTo(duration: duration1, percent: 1.0)
        let calFun = CCActionCallFunc(target:self, selector: Selector("progressTimeout"))
        
        let array1:[AnyObject] = [progres, calFun]
        let seq1 = CCActionSequence(array:array1)

        mProgressBar.runAction(seq1)
        
        for i in 0...9
        {
            mNumTiles[i].enabled = true;
        }
        
    }
    
    func progressTimeout()
    {
        mProgressBar.stopAllActions()
        
        mIsGameStarted = false;
        
        for i in 0...9
        {
            mNumTiles[i].enabled = false;
        }
        
        YSSoundUtils.sharedSoundUtils.playEndWarnSFX()
        
        self.ShowGameOver();
    }
    
    
    
    func getProgressDuration()->Double
    {
        var dur = 0 as Double
    
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            if(YSGameManager.sharedGameManager.currentLevel<5)
            {
                dur = 15.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<10)
            {
                dur = 10.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<20)
            {
                dur = 8.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<30)
            {
                dur = 7.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<40)
            {
                dur = 2.0 ;
            }
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            if(YSGameManager.sharedGameManager.currentLevel==1)
            {
                dur = 6.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel==2)
            {
                dur = 5.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel==3)
            {
                dur = 4.5 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<10)
            {
                dur = 3.5 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<15)
            {
                dur = 3.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<20)
            {
                dur = 2.75 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<30)
            {
                dur = 2.25 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<40)
            {
                dur = 2.5 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<50)
            {
                dur = 2.0 ;
            }
            else
            {
                dur = 1.0 ;
            }
    
        }
        else
        {
            if(YSGameManager.sharedGameManager.currentLevel==1)
            {
                dur = 3.0 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel==2)
            {
                dur = 2.5 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel==3)
            {
                dur = 2.2 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<10)
            {
                dur = 2.1 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<15)
            {
                dur = 1.75 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<20)
            {
                dur = 1.5 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<30)
            {
                dur = 1.25 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<40)
            {
                dur = 1.15 ;
            }
            else if(YSGameManager.sharedGameManager.currentLevel<50)
            {
                dur = 1.0 ;
            }
            else
            {
                dur = 0.7 ;
            }
        }
    
        return dur;
    }
    
    func tileBtn_1_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
 
        self.processDigit(1);
    }
    
    func tileBtn_2_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(2);
    }
    
    func tileBtn_3_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(3);
    }
    
    func tileBtn_4_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(4);
    }
    
    func tileBtn_5_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(5);
    }
  
    
    func tileBtn_6_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(6);
    }
    
    
    func tileBtn_7_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(7);
    }
    
    
    func tileBtn_8_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(8);
    }
    
    func tileBtn_9_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(9);
    }
    
    func tileBtn_0_Press()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        self.processDigit(0);
    }
    
    func processResult()
    {
        if(mKeyboard_Input == mMaths.result_num)
        {
            self.mEmiter.resetSystem()
            
            YSSoundUtils.sharedSoundUtils.playCorrectPressSFX()
            
            for i in 0...9
            {
                mNumTiles[i].enabled = false;
            }
            
            mProgressBar.stopAllActions()
            mProgressBar.percentage = 0.0;
            
            YSGameManager.sharedGameManager.levelScore++;
            
            
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
            {
                if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Normal)
                {
                    YSGameManager.sharedGameManager.highScore_Normal = YSGameManager.sharedGameManager.levelScore;
                }
            }
            else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Kids)
                {
                    YSGameManager.sharedGameManager.highScore_Kids = YSGameManager.sharedGameManager.levelScore;
                }
            }
            else
            {
                if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Expert)
                {
                    YSGameManager.sharedGameManager.highScore_Expert = YSGameManager.sharedGameManager.levelScore;
                }
            }
            
            if(YSGameManager.sharedGameManager.currentLevel > 3)
            {
                if(mProgressBar.percentage>50 )
                {
                    YSGameManager.sharedGameManager.levelScore++;
                    
                    self.showBonusLabel();
                }
            }
            
            mLevelNumber.string = NSString(format:"%d", YSGameManager.sharedGameManager.levelScore) as String
            
            if(YSGameManager.sharedGameManager.levelScore > 99)
            {
                mLevelNumber.fontSize = (isPad) ? 45 : 20 ;
            }
            
            let move = CCActionMoveTo.actionWithDuration(0.3, position: ccp(-SW,0.0)) as! CCActionMoveTo
            
            let calBck  = CCActionCallBlock.actionWithBlock({
                self.mOperatorNode.stopAllActions()
                self.mOperatorNode.position = ccp(SW,0.0);
                self.mEmiter.stopSystem()
                self.startGame()
                
            }) as! CCActionCallBlock
            
            let array: [AnyObject] = [move, calBck]
            
            let seq  = CCActionSequence.actionWithArray(array) as!  CCActionSequence
            
            mOperatorNode.stopAllActions()
            mOperatorNode.runAction(seq)
        }
        else
        {
            if(YSGameManager.sharedGameManager.gGameMode != Game_Mode.kGameMode_KidsMode)
            {
                YSSoundUtils.sharedSoundUtils.playEndWarnSFX()
                mProgressBar.stopAllActions()
                mProgressBar.percentage = 0.0;
                
                self.ShowGameOver()
            }
            else
            {
                YSSoundUtils.sharedSoundUtils.playEndWarnSFX()
                
                //handle wrong input
                
                mKeyboard_Input = 0;
                mKeyboard_Count = 0;
                
                let frame = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Tile_Wrong_Result.png") as CCSpriteFrame
                mResult_Tile.spriteFrame = frame
            }
        }
    }
    
    func processDigit(inDigit:Int )
    {
        if(mIsGameStarted)
        {
            let frame = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Tile_Operator.png") as CCSpriteFrame

            mResult_Tile.spriteFrame = frame
            
            mKeyboard_Count++;
            
            mKeyboard_Input = mKeyboard_Input*10 + inDigit;
            
            if(mKeyboard_Count==mMaths.result_Digit_Count)
            {
                let str = NSString(format:"=%d", mKeyboard_Input) as String
                mLabel_Result.string = str
                
                self.processResult();
            }
            else
            {
                var result_String = NSString(format:"=%d", mKeyboard_Input) as String
                
                for var i = 0; i < (mMaths.result_Digit_Count-mKeyboard_Input); i++
                {
                    result_String = result_String.stringByAppendingString("?")
                }
                mLabel_Result.string = result_String
            }

        }
        
     }
    
    func showBonusLabel()
    {
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 30 : 15 as CGFloat
        
        let bonusLabel = CCLabelTTF(string:"Bonus: +1", fontName:fntName, fontSize: fntSize)
        bonusLabel.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        bonusLabel.position = ccp(SW*0.4935, SH*0.9180)
        bonusLabel.anchorPoint = ccp(0.5, 0.5)
        self.addChild(bonusLabel, z:6)
        bonusLabel.scale = 0.0;
        
        let scale = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 0.2, scale: 1.0), period: 0.3)
        let fade  = CCActionFadeOut(duration: 1.5)
        let calB  = CCActionCallBlock(block: ({
                        bonusLabel.stopAllActions()
                        bonusLabel.removeFromParentAndCleanup(true)
                    }))

        let array1:[AnyObject] = [scale, fade, calB]
        let seq = CCActionSequence(array: array1)
        bonusLabel.runAction(seq)
    }

    func ShowGameOver()
    {
        
        OALSimpleAudio.sharedInstance().stopBg()
 
        let move = CCActionMoveTo(duration: 0.3, position: ccp(-SW,0))
        let calB  = CCActionCallBlock(block: ({
            self.showGameOverText()
        }))
        
        let array1:[AnyObject] = [move, calB]
        let seq = CCActionSequence(array: array1)
        mOperatorNode.stopAllActions()
        mOperatorNode.runAction(seq)
 
    }
    
    
    func showGameOverText()
    {
        let GOTextNode = CCNode()
        GOTextNode.anchorPoint = ccp(0.0,0.0);
        self.addChild(GOTextNode, z:6)
        
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 80 : 40 as CGFloat
        
        let labelGameOver = CCLabelTTF(string:"GAME OVER", fontName:fntName, fontSize: fntSize)
        labelGameOver.color = CCColor(red: 1.0, green: 1.0, blue: 1.0)
        labelGameOver.position = ccp(0.0,0.0)
        labelGameOver.anchorPoint = ccp(0.5, 0.5)
        
        let labelGameOverShaddow = CCLabelTTF(string:"GAME OVER", fontName:fntName, fontSize: fntSize)
        labelGameOverShaddow.color = CCColor(red: 0.7, green: 0.3, blue: 0.2)
        labelGameOverShaddow.position = ccp(0.0,0.0)
        labelGameOverShaddow.anchorPoint = ccp(0.5, 0.5)
        GOTextNode.addChild(labelGameOverShaddow, z:6)
        GOTextNode.addChild(labelGameOver, z:6)

        labelGameOverShaddow.scale = 1.05;
        GOTextNode.position = ccp(SW*0.5, SH*0.7520);
        GOTextNode.visible = false;

        let delay1 = CCActionDelay(duration: 0.5)
        let calFun1 = CCActionCallBlock(block: ({
            GOTextNode.scale=2.2;
            GOTextNode.visible = true;
        }))
        let scale = CCActionScaleTo(duration: 0.3, scale: 1.0)
        let delay2 = CCActionDelay(duration: 0.5)
        let calFun2 = CCActionCallBlock(block: ({
            GOTextNode.stopAllActions()
            GOTextNode.removeFromParentAndCleanup(true)
            self.removeUIElements()
        }))
        
        let array1:[AnyObject] = [delay1, calFun1, scale, delay2, calFun2]
        let seq = CCActionSequence(array: array1)
        GOTextNode.runAction(seq)
    }
    
    func removeUIElements()
    {
        let moveBy11 = CCActionMoveBy(duration: 0.3, position: ccp(0, -SH*0.05))
        let moveBy12 = CCActionMoveTo(duration: 1.5, position: ccp(mProgressBgNode.position.x, SH*1.3))
        let elastic11  = CCActionEaseElastic(action: moveBy12)
        let array11:[AnyObject] = [moveBy11, elastic11]
        let seq11 = CCActionSequence (array: array11)
        mProgressBgNode.runAction(seq11)
            
            
        let moveBy21 = CCActionMoveBy(duration: 0.3, position: ccp(0, -SH*0.05))
        let moveBy22 = CCActionMoveTo(duration: 1.5, position: ccp(mLevelTile.position.x, SH*1.3))
        let elastic21  = CCActionEaseElastic(action: moveBy22)
        let array21:[AnyObject] = [moveBy21, elastic21]
        let seq21 = CCActionSequence (array: array21)
        mLevelTile.runAction(seq21)

        
        for i in 1...3
        {
            let moveBy31 = CCActionMoveBy(duration: 0.3, position: ccp(0, +SH*0.08))
            let moveBy32 = CCActionMoveBy(duration: 1.2, position: ccp(0, -SH*0.8))
            let elastic  = CCActionEaseElastic(action: moveBy32)
            
            let array31:[AnyObject] = [moveBy31, elastic]
            let seq31 = CCActionSequence (array: array31)
            
            mNumTiles[i].runAction(seq31)
        }
        
        
        for i in 4...6
        {
            let moveBy31 = CCActionMoveBy(duration: 0.4, position: ccp(0, +SH*0.05))
            let moveBy32 = CCActionMoveBy(duration: 1.2, position: ccp(0, -SH*1.0))
            let elastic  = CCActionEaseElastic(action: moveBy32)
            
            let array31:[AnyObject] = [moveBy31, elastic]
            let seq31 = CCActionSequence (array: array31)
            
            mNumTiles[i].runAction(seq31)
        }
        
        for i in 7...9
        {
            let moveBy31 = CCActionMoveBy(duration: 0.5, position: ccp(0, +SH*0.03))
            let moveBy32 = CCActionMoveBy(duration: 1.3, position: ccp(0, -SH*1.2))
            let elastic  = CCActionEaseElastic(action: moveBy32)
            
            let array31:[AnyObject] = [moveBy31, elastic]
            let seq31 = CCActionSequence (array: array31)
            
            mNumTiles[i].runAction(seq31)
        }
        
        let moveBy31 = CCActionMoveBy(duration: 0.8, position: ccp(0, +SH*0.05))
        let moveBy32 = CCActionMoveBy(duration: 1.2, position: ccp(0, -SH*1.6))
        let elastic  = CCActionEaseElastic(action: moveBy32)
        let calF     = CCActionCallFunc(target: self, selector: Selector("showGameOverStats"))
        
        let array31:[AnyObject] = [moveBy31, elastic, calF]
        let seq31 = CCActionSequence (array: array31)
        
        mNumTiles[0].runAction(seq31)
    }
    
    
    func showGameOverStats()
    {
        YSSoundUtils.sharedSoundUtils.playGameOverSFX()
        
        let logo = CCSprite(imageNamed: "Title_Logo.png")
        logo.position  = ccp(SW*0.5, SH+logo.contentSize.height*0.5)
        self.addChild(logo, z:6)

        let pos = ccp(SW*0.5, SH*0.85) as  CGPoint
        
        let move = CCActionEaseElasticOut(action: CCActionMoveTo(duration: 2.5, position: pos), period: 0.3)
        logo.runAction(move)
        
        let statsNode = CCNode()
        statsNode.position = ccp(SW,0.0)
        self.addChild(statsNode, z:7)
 
        
        let frame1 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("gameOverBG.png") as CCSpriteFrame

        let statsBg = CCSprite(spriteFrame: frame1)
        statsBg.position  = ccp(SW*0.5, SH*0.55)
        statsNode.addChild(statsBg, z:4)

        var levelTxt:String
        
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            levelTxt = NSString(format: "Normal Mode : Level %d", YSGameManager.sharedGameManager.currentLevel) as String
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            levelTxt = NSString(format: "Kids Mode : Level %d", YSGameManager.sharedGameManager.currentLevel) as String
        }
        else
        {
            levelTxt = NSString(format: "Expert Mode : Level %d", YSGameManager.sharedGameManager.currentLevel) as String
        }

        
        let fntName:String = "AvenirNext-Bold"
        let fntSize = (isPad) ? 32 : 16 as CGFloat
        
        let levelLbl_shadw = CCLabelTTF(string:levelTxt, fontName:fntName, fontSize: fntSize)
        levelLbl_shadw.color = CCColor(red: 0.0, green: 0.0, blue: 0.0)
        levelLbl_shadw.position = ccp(SW*0.5-2, SH*0.64-2)
        levelLbl_shadw.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(levelLbl_shadw, z:8)
        
        let levelLbl = CCLabelTTF(string:levelTxt, fontName:fntName, fontSize: fntSize)
        levelLbl.color = CCColor(red: 1.0, green: 0.9, blue: 0.8)
        levelLbl.position = ccp(SW*0.5, SH*0.64)
        levelLbl.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(levelLbl, z:8)
        
        
        let fntSize2 = (isPad) ? 70 : 35 as CGFloat

        let scoreText = NSString(format: "Score: %d", YSGameManager.sharedGameManager.levelScore) as String

        let scoreLabel_Shadw = CCLabelTTF(string:scoreText, fontName:fntName, fontSize: fntSize2)
        scoreLabel_Shadw.color = CCColor(red: 0.0, green: 0.0, blue: 0.0)
        scoreLabel_Shadw.position = ccp(SW*0.5-2, SH*0.57-2)
        scoreLabel_Shadw.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(scoreLabel_Shadw, z:8)
 
            
        let scoreLabel = CCLabelTTF(string:scoreText, fontName:fntName, fontSize: fntSize2)
        scoreLabel.color = CCColor(red: 1.0, green: 1.0, blue: 0.0)
        scoreLabel.position = ccp(SW*0.5, SH*0.57)
        scoreLabel.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(scoreLabel, z:8)
        
      
        var highScr:Int = 0
      
        
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            highScr = YSGameManager.sharedGameManager.highScore_Normal;
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            highScr = YSGameManager.sharedGameManager.highScore_Kids;
        }
        else
        {
            highScr = YSGameManager.sharedGameManager.highScore_Expert;
        }
        
        let bestText = NSString(format: "Best: %d", highScr) as String
      
        let fntSize3 = (isPad) ? 36 : 20 as CGFloat

        let highScoreLabel_Shadw = CCLabelTTF(string:bestText, fontName:fntName, fontSize: fntSize3)
        highScoreLabel_Shadw.color = CCColor(red: 0.0, green: 0.0, blue: 0.0)
        highScoreLabel_Shadw.position = ccp(SW*0.5-2, SH*0.5-2)
        highScoreLabel_Shadw.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(highScoreLabel_Shadw, z:8)

        let highScoreLabel = CCLabelTTF(string:bestText, fontName:fntName, fontSize: fntSize3)
        highScoreLabel.color = CCColor(red: 0.3, green: 0.8, blue: 0.2)
        highScoreLabel.position = ccp(SW*0.5, SH*0.5)
        highScoreLabel.anchorPoint = ccp(0.5, 0.5)
        statsNode.addChild(highScoreLabel, z:8)
        
 
        
        if(YSGameManager.sharedGameManager.maxLevel < YSGameManager.sharedGameManager.currentLevel)
        {
            YSGameManager.sharedGameManager.maxLevel = YSGameManager.sharedGameManager.currentLevel
        }
        
        
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Normal)
            {
                YSGameManager.sharedGameManager.highScore_Normal = YSGameManager.sharedGameManager.levelScore;
            }
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Kids)
            {
                YSGameManager.sharedGameManager.highScore_Kids = YSGameManager.sharedGameManager.levelScore;
            }
        }
        else
        {
            if(YSGameManager.sharedGameManager.levelScore > YSGameManager.sharedGameManager.highScore_Expert)
            {
                YSGameManager.sharedGameManager.highScore_Expert = YSGameManager.sharedGameManager.levelScore;
            }
        }
        
        var highScore:Int!
        
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportScore(YSGameManager.sharedGameManager.highScore_Normal,leaderboardID:kLeaderboardID_Normal)
            
            highScore = YSGameManager.sharedGameManager.highScore_Normal
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportScore(YSGameManager.sharedGameManager.highScore_Kids,leaderboardID:kLeaderboardID_Kids)
            
            highScore = YSGameManager.sharedGameManager.highScore_Kids

        }
        else
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportScore(YSGameManager.sharedGameManager.highScore_Expert,leaderboardID:kLeaderboardID_Expert)
            
            highScore = YSGameManager.sharedGameManager.highScore_Expert

        }
        
        
        if(highScore >= SCORE_ACH_10)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_10_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_9_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_8_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_7_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_6_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_9)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_9_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_8_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_7_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_6_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_8)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_8_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_7_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_6_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_7)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_7_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_6_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_6)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_6_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_5)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_5_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_4)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_4_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_3)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_3_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_2)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_2_ID, perecent: 100)
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievementsF(ACH_1_ID, perecent: 100)
        }
        else if(highScore >= SCORE_ACH_1)
        {
            YSGamecenterUtils.sharedGamecenterUtils.reportAchievements(ACH_1_ID, perecent: 100)
        }

        
        
        let moveTo = CCActionEaseElasticOut(action: CCActionMoveTo(duration: 1.5, position: ccp(0.0,0.0)), period: 0.3)
        let calFun = CCActionCallFunc(target: self, selector: Selector("showGameOverButtons"))
        let array1:[AnyObject] = [moveTo, calFun]
        let seq = CCActionSequence(array: array1)
        statsNode.runAction(seq)
        
    }
    
    func showGameOverButtons()
    {
        self.checkAchievements()
        
        let playMenuNode = CCNode()
        self.addChild(playMenuNode, z:7)
        playMenuNode.position = ccp(-SW, 0.0)

 
        let frame1 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Play.png") as CCSpriteFrame
        let frame2 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Play.png") as CCSpriteFrame
        let frame3 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Play.png") as CCSpriteFrame
        
        let playBtn = CCButton(title: "", spriteFrame: frame1, highlightedSpriteFrame: frame2, disabledSpriteFrame: frame3)
        playBtn.setTarget(self, selector: Selector("playBtnPress"))
        playBtn.position = ccp(SW*0.3, SH*0.3) ;
        playMenuNode.addChild(playBtn, z:3)
        playBtn.zoomWhenHighlighted = true

        let frame4 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_More.png") as CCSpriteFrame
        let frame5 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_More.png") as CCSpriteFrame
        let frame6 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_More.png") as CCSpriteFrame
        
        let moreBtn = CCButton(title: "", spriteFrame: frame4, highlightedSpriteFrame: frame5, disabledSpriteFrame: frame6)
        moreBtn.setTarget(self, selector: Selector("moreBtnPress"))
        moreBtn.position = ccp(SW*0.5, SH*0.3)
        playMenuNode.addChild(moreBtn, z:3)
        moreBtn.zoomWhenHighlighted = true

        let frame7 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Home.png") as CCSpriteFrame
        let frame8 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Home.png") as CCSpriteFrame
        let frame9 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btn_GO_Home.png") as CCSpriteFrame
        
        let homeBtn = CCButton(title: "", spriteFrame: frame7, highlightedSpriteFrame: frame8, disabledSpriteFrame: frame9)
        homeBtn.setTarget(self, selector: Selector("homeBtnPress"))
        homeBtn.position = ccp(SW*0.7, SH*0.3)
        playMenuNode.addChild(homeBtn, z:3)
        homeBtn.zoomWhenHighlighted = true
        
        let moveTo = CCActionEaseElasticOut(action: CCActionMoveTo(duration: 1.5, position: ccp(0.0,0.0)), period: 0.3)
        let calFun = CCActionCallFunc(target: self, selector: Selector("showGameOverSocialButtons"))
        let array1:[AnyObject] = [moveTo, calFun]
        let seq = CCActionSequence(array: array1)
        
        playMenuNode.runAction(seq)
    }
    
    
    func showGameOverSocialButtons()
    {
        let frame1 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        let frame2 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        let frame3 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        
        let gcBtn = CCButton(title: "", spriteFrame: frame1, highlightedSpriteFrame: frame2, disabledSpriteFrame: frame3)
        gcBtn.setTarget(self, selector: Selector("gcBtnPress"))
        gcBtn.position = ccp(SW*0.1, SH*0.18)
        self.addChild(gcBtn, z:8)
        gcBtn.zoomWhenHighlighted = true;
        gcBtn.scale = 0.0;

        let frame4 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        let frame5 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        let frame6 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        
        let fbBtn = CCButton(title: "", spriteFrame: frame4, highlightedSpriteFrame: frame5, disabledSpriteFrame: frame6)
        fbBtn.setTarget(self, selector: Selector("fbBtnPress"))
        fbBtn.position = ccp(SW*0.3, SH*0.18)
        self.addChild(fbBtn, z:8)
        fbBtn.zoomWhenHighlighted = true;
        fbBtn.scale = 0.0;
        
        
        let frame7 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        let frame8 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        let frame9 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        
        let twrBtn = CCButton(title: "", spriteFrame: frame7, highlightedSpriteFrame: frame8, disabledSpriteFrame: frame9)
        twrBtn.setTarget(self, selector: Selector("twrBtnPress"))
        twrBtn.position = ccp(SW*0.5, SH*0.18)
        self.addChild(twrBtn, z:8)
        twrBtn.zoomWhenHighlighted = true;
        twrBtn.scale = 0.0;

 
        
        let frame10 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        let frame11 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        let frame12 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        
        let emailBtn = CCButton(title: "", spriteFrame: frame10, highlightedSpriteFrame: frame11, disabledSpriteFrame: frame12)
        emailBtn.setTarget(self, selector: Selector("emailBtnPress"))
        emailBtn.position = ccp(SW*0.7, SH*0.18)
        self.addChild(emailBtn, z:8)
        emailBtn.zoomWhenHighlighted = true;
        emailBtn.scale = 0.0;

       
        
        let frame13 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        let frame14 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        let frame15 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        
        let smsBtn = CCButton(title: "", spriteFrame: frame13, highlightedSpriteFrame: frame14, disabledSpriteFrame: frame15)
        smsBtn.setTarget(self, selector: Selector("smsBtnPress"))
        smsBtn.position = ccp(SW*0.9, SH*0.18)
        self.addChild(smsBtn, z:8)
        smsBtn.zoomWhenHighlighted = true;
        smsBtn.scale = 0.0;
        
        
        YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()

        let scale1 = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 1.0, scale: 1.0), period: 0.3)
        gcBtn.runAction(scale1)
        
        let delay2 = CCActionDelay(duration: 0.3)
        let calB2   = CCActionCallBlock(block: ({
                    YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
                }))
  
        let scale2 = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 1.0, scale: 1.0), period: 0.3)
        let array2:[AnyObject] = [delay2, calB2, scale2]
        let seq2 = CCActionSequence(array: array2)
        fbBtn.runAction(seq2)
            
            
        let delay3 = CCActionDelay(duration: 0.6)
        let calB3   = CCActionCallBlock(block: ({
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
        }))
        
        let scale3 = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 1.0, scale: 1.0), period: 0.3)
        let array3:[AnyObject] = [delay3, calB3, scale3]
        let seq3 = CCActionSequence(array: array3)
        twrBtn.runAction(seq3)
            
        let delay4 = CCActionDelay(duration: 0.9)
        let calB4   = CCActionCallBlock(block: ({
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
        }))
        
        let scale4 = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 1.0, scale: 1.0), period: 0.3)
        let array4:[AnyObject] = [delay4, calB4, scale4]
        let seq4 = CCActionSequence(array: array4)
        emailBtn.runAction(seq4)
         
            
        let delay5 = CCActionDelay(duration: 1.2)
        let calB5   = CCActionCallBlock(block: ({
            
            NSNotificationCenter.defaultCenter().postNotificationName("showFullScreenAds", object: nil)
            
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
        }))
        
        let scale5 = CCActionEaseElasticOut(action: CCActionScaleTo(duration: 1.0, scale: 1.0), period: 0.3)
        let array5:[AnyObject] = [delay5, calB5, scale5]
        let seq5 = CCActionSequence(array: array5)
        smsBtn.runAction(seq5)
        
        YSGameManager.sharedGameManager.savePreference()
        
        
       // [App showFullScreenAds];

    }
    
    func playBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        YSGameManager.sharedGameManager.replaceGameScene(GameScreen.kSceneGameScreen)
    }
    
    func moreBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
    
          NSNotificationCenter.defaultCenter().postNotificationName("showMoreGames", object: nil)
    }
    
    func emailBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        var image:UIImage!
        image = takePresentScreenshot()
        
        YSGameManager.sharedGameManager.emailBtnPress(image)
        
    }
    
    func homeBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
    
        YSGameManager.sharedGameManager.replaceGameScene(GameScreen.kSceneMainMenu)
    
        NSNotificationCenter.defaultCenter().postNotificationName("showFullScreenAds", object: nil)
    }
    
    
    func gameCenterBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Normal)
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Kids)
        }
        else
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Kids)
        }

    }
    
    func takePresentScreenshot()->UIImage
    {
        CCDirector.sharedDirector().nextDeltaTimeZero = true;
        
        let size = CCDirector.sharedDirector().viewSize() as CGSize
        
        let width1 = Int32(size.width)
        let height1 = Int32(size.height)

        let renderTxture = CCRenderTexture(width: width1, height: height1)
        renderTxture.begin()
        CCDirector.sharedDirector().runningScene.visit()
        renderTxture.end()
        
        return renderTxture.getUIImage()
    }
    
    func twrBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        var image:UIImage!
        image = takePresentScreenshot()
        
        YSGameManager.sharedGameManager.twitterBtnPress(image)
    }
    
    func fbBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        var image:UIImage!
        image = takePresentScreenshot()
        
        YSGameManager.sharedGameManager.facebookBtnPress(image)
    }
    
    func smsBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        YSGameManager.sharedGameManager.smsBtnPress()
    }
    
    
    func gcBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
    
        if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_NormalMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Normal)
        }
        else if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Kids)
        }
        else
        {
            YSGamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(CCDirector.sharedDirector(), leaderboardID: kLeaderboardID_Kids)
        }
    }

    
    func checkAchievements()
    {
        
    }
    
    
    
    
}
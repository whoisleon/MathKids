import Foundation

 


let SW = CCDirector.sharedDirector().viewSize().width;
let SH = CCDirector.sharedDirector().viewSize().height;

@objc(MainScene)

class MainScene: CCScene {

    var mPlayBtn:CCButton!
    var mTopScoreBtn:CCButton!
    var mMoreBtn:CCButton!
    var mKidsMode:CCButton!
    var mNormalMode:CCButton!
    var mExpertMode:CCButton!

    var mKidsLock:CCSprite!
    var mExpertLock:CCSprite!

    class func scene() -> MainScene
    {
        return MainScene()
    }
    
    
    override init()
    {
        super.init()
        self.userInteractionEnabled = true
        
        YSGamecenterUtils.sharedGamecenterUtils.authenticateLocalUserOnViewController(CCDirector.sharedDirector())
        
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("SpriteSheet_1.plist", textureFilename: "SpriteSheet_1.png")

        YSSoundUtils.sharedSoundUtils.preloadSFX()

        setupBackground()
        setupMenu()
                
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("InApPurchased_Kids:"),
            name: "IAUtilsPurchased_Kids",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("InApPurchased_Expert:"),
            name: "IAUtilsPurchased_Expert",
            object: nil)
    }
    
    func InApPurchased_Kids(inNotif:NSNotification)
    {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isKidsModeUnlocked")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        mKidsLock.visible = false ;
    }
    
    func InApPurchased_Expert(inNotif:NSNotification)
    {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isExpertModeUnlocked")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        mExpertLock.visible = false ;
        
    }
    
    func setupBackground()
    {
        let bg = CCSprite(imageNamed:"BG.png")
        bg.position = ccp(SW*0.5, SH*0.5);
        self.addChild(bg, z: 2);
        
        let logo = CCSprite(imageNamed:"Title_Logo.png")
        logo.position  = ccp(SW*0.5, SH+logo.contentSize.height*0.5);
        self.addChild(logo, z:3)
        
        let pos = ccp(SW*0.5, SH*0.85) as CGPoint
        
        let move    = CCActionEaseElasticOut.actionWithAction(CCActionMoveTo.actionWithDuration(2.0, position: pos) as! CCActionMoveTo) as! CCActionEaseElasticOut
        let delay   = CCActionDelay.actionWithDuration(5.0) as! CCActionDelay
        
        let calBck  = CCActionCallBlock.actionWithBlock({
                self.showGlassEffect(logo)
        }) as! CCActionCallBlock
        
        
         let array: [AnyObject] = [move, delay, calBck]
        
        let seq  = CCActionSequence.actionWithArray(array) as!  CCActionSequence
        
        logo.runAction(seq)
     }
    func showGlassEffect(effectBG:CCSprite)
    {
//        effectBG.visible = false;
//
//        var normalMap = CCSpriteFrame(imageNamed: "effectsImage.png")
//        var reflectEnvironment = CCSprite(imageNamed:"effectsGlass.jpg")
//        reflectEnvironment.position = ccp(SW*0.5, SH*0.5);
//        reflectEnvironment.visible = false;
//        self.addChild(reflectEnvironment, z:4)
//        
//        var glass = CCEffectGlass.effectWithShininess(1.0, refraction: 1.0, refractionEnvironment: effectBG, reflectionEnvironment: reflectEnvironment) as CCEffectGlass
//        glass.fresnelBias = 0.1;
//        glass.fresnelPower = 2.0;
//        glass.refraction = 0.75;
//        
//        var sprite1 = CCSprite(imageNamed:"effectsGlass.jpg")
//        sprite1.position = ccp(SW*0.1, SH*0.82);
//        sprite1.normalMapSpriteFrame = normalMap;
//        sprite1.effect = glass;
//        sprite1.scale = (isPad ) ? 1.3 : 0.7
//        
//        sprite1.colorRGBA = CCColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0) ;
//        self.addChild(sprite1, z:5)
//
//        
//        var duration = (isPad) ? 2.0 : 1.25 ;
//        
//        var action1 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.8, SH*0.82)) as! CCActionMoveTo
//        var action2 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.1, SH*0.82)) as! CCActionMoveTo
//        var action3 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.8, SH*0.82)) as! CCActionMoveTo
//        var action4 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.1, SH*0.82)) as! CCActionMoveTo
//
//        
//        var action5 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.8, SH*0.52)) as! CCActionMoveTo
//        var action6 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*0.1, SH*0.18)) as! CCActionMoveTo
//        var action7 = CCActionMoveTo.actionWithDuration(duration, position: ccp(SW*1.2, SH*0.18)) as! CCActionMoveTo
//
//        let array:[AnyObject] = [action1, action2, action3, action4, action5, action6, action7]
//        
//        var seq  = CCActionSequence.actionWithArray(array) as!  CCActionSequence
//
//        var rep = CCActionRepeatForever.actionWithAction(seq) as! CCActionRepeatForever
//        
//        sprite1.runAction(rep)
        

         NSNotificationCenter.defaultCenter().postNotificationName("showAdmobBanner", object: nil)
    }
    
    func setupMenu()
    {
        let frame11 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnPlay.png") as CCSpriteFrame
        let frame12 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnPlay.png") as CCSpriteFrame
        let frame13 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnPlay.png") as CCSpriteFrame
        
        mPlayBtn = CCButton.buttonWithTitle("", spriteFrame: frame11, highlightedSpriteFrame:frame12, disabledSpriteFrame: frame13) as! CCButton
        mPlayBtn.setTarget(self, selector: Selector("playBtnPress"))
        mPlayBtn.position = ccp(SW*0.5, -mPlayBtn.contentSize.height*0.5) ;
        mPlayBtn.zoomWhenHighlighted = true;
        self.addChild(mPlayBtn, z:5)
        mPlayBtn.enabled = false;
        
        
        let frame21 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnTopScore.png") as CCSpriteFrame
        let frame22 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnTopScore.png") as CCSpriteFrame
        let frame23 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnTopScore.png") as CCSpriteFrame
        
        mTopScoreBtn = CCButton.buttonWithTitle("", spriteFrame: frame21, highlightedSpriteFrame:frame22, disabledSpriteFrame: frame23) as! CCButton
        mTopScoreBtn.setTarget(self, selector: Selector("gameCenterBtnPress"))
        mTopScoreBtn.position = ccp(SW*0.5, -mTopScoreBtn.contentSize.height*0.5) ;
        mTopScoreBtn.zoomWhenHighlighted = true;
        self.addChild(mTopScoreBtn, z:5)
        mTopScoreBtn.enabled = false;
        
        
        let frame31 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnMore.png") as CCSpriteFrame
        let frame32 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnMore.png") as CCSpriteFrame
        let frame33 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnMore.png") as CCSpriteFrame
        
        mMoreBtn = CCButton.buttonWithTitle("", spriteFrame: frame31, highlightedSpriteFrame:frame32, disabledSpriteFrame: frame33) as! CCButton
        mMoreBtn.setTarget(self, selector: Selector("moreBtnPress"))
        mMoreBtn.position = ccp(SW*0.5, -mMoreBtn.contentSize.height*0.5) ;
        mMoreBtn.zoomWhenHighlighted = true;
        self.addChild(mMoreBtn, z:5)
        mMoreBtn.enabled = false;
        
        let frame41 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        let frame42 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        let frame43 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Gamecenter.png") as CCSpriteFrame
        
        let gcBtn = CCButton.buttonWithTitle("", spriteFrame: frame41, highlightedSpriteFrame:frame42, disabledSpriteFrame: frame43) as! CCButton
        gcBtn.setTarget(self, selector: Selector("gcBtnPress"))
        gcBtn.position = ccp(SW*0.1, SH*0.18) ;
        gcBtn.zoomWhenHighlighted = true;
        self.addChild(gcBtn, z:5)
        gcBtn.scale = 0.0;
        
        
        let frame51 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        let frame52 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        let frame53 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_facebook.png") as CCSpriteFrame
        
        let fbBtn = CCButton.buttonWithTitle("", spriteFrame: frame51, highlightedSpriteFrame:frame52, disabledSpriteFrame: frame53) as! CCButton
        fbBtn.setTarget(self, selector: Selector("fbBtnPress"))
        fbBtn.position = ccp(SW*0.3, SH*0.18) ;
        fbBtn.zoomWhenHighlighted = true;
        self.addChild(fbBtn, z:5)
        fbBtn.scale = 0.0;
 
        
        let frame61 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        let frame62 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        let frame63 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_twitter.png") as CCSpriteFrame
        
        let twrBtn = CCButton.buttonWithTitle("", spriteFrame: frame61, highlightedSpriteFrame:frame62, disabledSpriteFrame: frame63) as! CCButton
        twrBtn.setTarget(self, selector: Selector("twrBtnPress"))
        twrBtn.position = ccp(SW*0.5, SH*0.18) ;
        twrBtn.zoomWhenHighlighted = true;
        self.addChild(twrBtn, z:5)
        twrBtn.scale = 0.0;
    
        
        let frame71 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        let frame72 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        let frame73 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Email.png") as CCSpriteFrame
        
        let emailBtn = CCButton.buttonWithTitle("", spriteFrame: frame71, highlightedSpriteFrame:frame72, disabledSpriteFrame: frame73) as! CCButton
        emailBtn.setTarget(self, selector: Selector("emailBtnPress"))
        emailBtn.position = ccp(SW*0.7, SH*0.18) ;
        emailBtn.zoomWhenHighlighted = true;
        self.addChild(emailBtn, z:5)
        emailBtn.scale = 0.0;
 
        
        
        let frame81 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        let frame82 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        let frame83 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("Icon_Message.png") as CCSpriteFrame
        
        let smsBtn = CCButton.buttonWithTitle("", spriteFrame: frame81, highlightedSpriteFrame:frame82, disabledSpriteFrame: frame83) as! CCButton
        smsBtn.setTarget(self, selector: Selector("smsBtnPress"))
        smsBtn.position = ccp(SW*0.9, SH*0.18) ;
        smsBtn.zoomWhenHighlighted = true;
        self.addChild(smsBtn, z:5)
        smsBtn.scale = 0.0;
        
        
        let pos11 = ccp(SW*0.5, SH*0.65) as  CGPoint
        let pos12 = ccp(SW*0.5, SH*0.6) as CGPoint
        
        
        let delay = CCActionDelay.actionWithDuration(1.0) as! CCActionDelay
        let calB = CCActionCallBlock.actionWithBlock({
                    YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
            }) as! CCActionCallBlock
        let move11  = CCActionMoveTo.actionWithDuration(0.4, position: pos11) as! CCActionMoveTo
        let moveTmp1 = CCActionMoveTo.actionWithDuration(0.3, position: pos12) as! CCActionMoveTo
        let move12  = CCActionEaseElasticOut.actionWithAction(moveTmp1) as! CCActionEaseElasticOut
        
        let array1:[AnyObject] = [delay,calB,move11,moveTmp1,move12]
        let seq1 = CCActionSequence.actionWithArray(array1) as! CCActionSequence
        mPlayBtn.runAction(seq1)
        
        
        let pos21 = ccp(SW*0.5, SH*0.5) as  CGPoint
        let pos22 = ccp(SW*0.5, SH*0.45) as CGPoint
        
        let delay2 = CCActionDelay.actionWithDuration(2.0) as! CCActionDelay
        let calB2 = CCActionCallBlock.actionWithBlock({
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
        }) as! CCActionCallBlock
        let move21  = CCActionMoveTo.actionWithDuration(0.3, position: pos21) as! CCActionMoveTo
        let moveTmp2 = CCActionMoveTo.actionWithDuration(0.3, position: pos22) as! CCActionMoveTo
        let move22  = CCActionEaseElasticOut.actionWithAction(moveTmp2, period: 0.1) as! CCActionEaseElasticOut
        let array2:[AnyObject] = [delay2,calB2,move21,moveTmp2,move22]
        let seq2 = CCActionSequence.actionWithArray(array2) as! CCActionSequence
        mTopScoreBtn.runAction(seq2)
            
        
        let pos31 = ccp(SW*0.5, SH*0.35) as  CGPoint
        let pos32 = ccp(SW*0.5, SH*0.3) as CGPoint
        
        
        let delay3 = CCActionDelay.actionWithDuration(3.0) as! CCActionDelay
        let calB3 = CCActionCallBlock.actionWithBlock({
            
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
            
        }) as! CCActionCallBlock
        let calB32 = CCActionCallBlock.actionWithBlock({
            self.mPlayBtn.enabled = true;
            self.mTopScoreBtn.enabled = true;
            self.mMoreBtn.enabled = true;
        }) as! CCActionCallBlock
        let move31  = CCActionMoveTo.actionWithDuration(0.3, position: pos31) as! CCActionMoveTo
        let moveTmp3 = CCActionMoveTo.actionWithDuration(0.3, position: pos32) as! CCActionMoveTo
        let move32  = CCActionEaseElasticOut.actionWithAction(moveTmp3, period: 0.1) as! CCActionEaseElasticOut
        let array3:[AnyObject] = [delay3,calB3,move31,moveTmp3,move32,calB32]
        let seq3 = CCActionSequence.actionWithArray(array3) as! CCActionSequence
        mMoreBtn.runAction(seq3)
     
        
        let delay4 = CCActionDelay.actionWithDuration(3.8) as! CCActionDelay
        let calB4 = CCActionCallBlock.actionWithBlock({
                YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
            }) as! CCActionCallBlock
        let scale11 = CCActionScaleTo.actionWithDuration(1.0, scale: 1.0) as! CCActionScaleTo
        let scale12 = CCActionEaseElasticOut.actionWithAction(scale11, period: 0.3) as! CCActionEaseElasticOut
        let array4:[AnyObject] = [delay4,calB4,scale12]
        let seq4 = CCActionSequence.actionWithArray(array4) as! CCActionSequence
        gcBtn.runAction(seq4)

        
        let delay5 = CCActionDelay.actionWithDuration(4.2) as! CCActionDelay
        let calB5 = CCActionCallBlock.actionWithBlock({
                YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
        }) as! CCActionCallBlock
        let scale21 = CCActionScaleTo.actionWithDuration(1.0, scale: 1.0) as! CCActionScaleTo
        let scale22 = CCActionEaseElasticOut.actionWithAction(scale21, period: 0.3) as! CCActionEaseElasticOut
        let array5:[AnyObject] = [delay5,calB5,scale22]
        let seq5 = CCActionSequence.actionWithArray(array5) as! CCActionSequence
        fbBtn.runAction(seq5)
        
        
        let delay6 = CCActionDelay.actionWithDuration(4.6) as! CCActionDelay
        let calB6 = CCActionCallBlock.actionWithBlock({
            
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()
            
        }) as! CCActionCallBlock
        let scale31 = CCActionScaleTo.actionWithDuration(1.0, scale: 1.0) as! CCActionScaleTo
        let scale32 = CCActionEaseElasticOut.actionWithAction(scale31, period: 0.3) as! CCActionEaseElasticOut
        let array6:[AnyObject] = [delay6,calB6,scale32]
        let seq6 = CCActionSequence.actionWithArray(array6) as! CCActionSequence
        twrBtn.runAction(seq6)
        

        let delay7 = CCActionDelay.actionWithDuration(5.0) as! CCActionDelay
        let calB7 = CCActionCallBlock.actionWithBlock({
            
            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()

        }) as! CCActionCallBlock
        let scale41 = CCActionScaleTo.actionWithDuration(1.0, scale: 1.0) as! CCActionScaleTo
        let scale42 = CCActionEaseElasticOut.actionWithAction(scale41, period: 0.3) as! CCActionEaseElasticOut
        let array7:[AnyObject] = [delay7,calB7,scale42]
        let seq7 = CCActionSequence.actionWithArray(array7) as! CCActionSequence
        emailBtn.runAction(seq7)
        
        let delay8 = CCActionDelay.actionWithDuration(5.4) as! CCActionDelay
        let calB8 = CCActionCallBlock.actionWithBlock({

            YSSoundUtils.sharedSoundUtils.playButtonUp2SFX()

        }) as! CCActionCallBlock
        let scale51 = CCActionScaleTo.actionWithDuration(1.0, scale: 1.0) as! CCActionScaleTo
        let scale52 = CCActionEaseElasticOut.actionWithAction(scale51, period: 0.3) as! CCActionEaseElasticOut
        let array8:[AnyObject] = [delay8,calB8,scale52]
        let seq8 = CCActionSequence.actionWithArray(array8) as! CCActionSequence
        smsBtn.runAction(seq8)
        

        let isKidsUnlocked:Bool = NSUserDefaults.standardUserDefaults().boolForKey("isKidsModeUnlocked")
        let isExpertUnlocked:Bool = NSUserDefaults.standardUserDefaults().boolForKey("isExpertModeUnlocked")
        
        
        let frame91 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnKidsMode.png") as CCSpriteFrame
        let frame92 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnKidsMode.png") as CCSpriteFrame
        let frame93 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnKidsMode.png") as CCSpriteFrame
        
        mKidsMode = CCButton.buttonWithTitle("", spriteFrame: frame91, highlightedSpriteFrame:frame92, disabledSpriteFrame: frame93) as! CCButton
        mKidsMode.setTarget(self, selector: Selector("kidsBtnPress"))
        mKidsMode.position = ccp(-mKidsMode.contentSize.width, SH*0.45) ;
        mKidsMode.zoomWhenHighlighted = true;
        self.addChild(mKidsMode, z:5)
        
        
        let frame101 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnNormalMode.png") as CCSpriteFrame
        let frame102 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnNormalMode.png") as CCSpriteFrame
        let frame103 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnNormalMode.png") as CCSpriteFrame
        
        mNormalMode = CCButton.buttonWithTitle("", spriteFrame: frame101, highlightedSpriteFrame:frame102, disabledSpriteFrame: frame103) as! CCButton
        mNormalMode.setTarget(self, selector: Selector("normalBtnPress"))
        mNormalMode.position = ccp(SW+mNormalMode.contentSize.width, SH*0.6) ;
        mNormalMode.zoomWhenHighlighted = true;
        self.addChild(mNormalMode, z:5)
        
 
        let frame111 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnExpertMode.png") as CCSpriteFrame
        let frame112 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnExpertMode.png") as CCSpriteFrame
        let frame113 = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("btnExpertMode.png") as CCSpriteFrame
        
        mExpertMode = CCButton.buttonWithTitle("", spriteFrame: frame111, highlightedSpriteFrame:frame112, disabledSpriteFrame: frame113) as! CCButton
        mExpertMode.setTarget(self, selector: Selector("expertBtnPress"))
        mExpertMode.position = ccp(SW+mExpertMode.contentSize.width, SH*0.3) ;
        mExpertMode.zoomWhenHighlighted = true;
        self.addChild(mExpertMode, z:5)
  

        
        if(!isKidsUnlocked)
        {
            let frame = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("lockIcon.png") as CCSpriteFrame

            mKidsLock = CCSprite.spriteWithSpriteFrame(frame) as! CCSprite
            mKidsLock.position = ccp(mKidsMode.contentSize.width*0.5,mKidsMode.contentSize.height*0.35);
            mKidsMode.addChild(mKidsLock)
        }

        
        if(!isExpertUnlocked)
        {
            let frame = CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName("lockIcon.png") as CCSpriteFrame
            
            mExpertLock = CCSprite.spriteWithSpriteFrame(frame) as! CCSprite
            mExpertLock.position = ccp(mExpertMode.contentSize.width*0.5,mExpertMode.contentSize.height*0.35);
            mExpertMode.addChild(mExpertLock)
        }
        
        
        
    }

    func playBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        animateNewButtons()
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
    
    func moreBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()

        NSNotificationCenter.defaultCenter().postNotificationName("showMoreGames", object: nil)

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
    
    func fbBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        var image:UIImage!
        image = UIImage(named: "Icon-152.png")
        
        YSGameManager.sharedGameManager.facebookBtnPress(image)

    }
    
    func twrBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        var image:UIImage!
        image = UIImage(named: "Icon-152.png")
        
        YSGameManager.sharedGameManager.twitterBtnPress(image)

    }
    
    func emailBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        var image:UIImage!
        image = UIImage(named: "Icon-152.png")
        
        YSGameManager.sharedGameManager.emailBtnPress(image)
        

    }
    
    func smsBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        YSGameManager.sharedGameManager.smsBtnPress()
    }
    
    func kidsBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        let isKidsUnlocked:Bool = NSUserDefaults.standardUserDefaults().boolForKey("isKidsModeUnlocked")
        
        if isKidsUnlocked
        {
            YSGameManager.sharedGameManager.gGameMode = Game_Mode.kGameMode_KidsMode
            
            YSGameManager.sharedGameManager.replaceGameScene(GameScreen.kSceneGameScreen)
        }
        else
        {
            YSInAppUtils.sharedInAppUtils.buyKidsmode()
        }
        
        
    }
    
    func normalBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        YSGameManager.sharedGameManager.gGameMode = Game_Mode.kGameMode_NormalMode
        
        YSGameManager.sharedGameManager.replaceGameScene(GameScreen.kSceneGameScreen)

    }
    
    func expertBtnPress()
    {
        YSSoundUtils.sharedSoundUtils.playButtonTapSFX()
        
        let isExpertUnlocked:Bool = NSUserDefaults.standardUserDefaults().boolForKey("isExpertModeUnlocked")
        
        if isExpertUnlocked
        {
            YSGameManager.sharedGameManager.gGameMode = Game_Mode.kGameMode_ExpertMode
            
            YSGameManager.sharedGameManager.replaceGameScene(GameScreen.kSceneGameScreen)
        }
        else
        {
            YSInAppUtils.sharedInAppUtils.buyExpertmode()
        }
    }
    
    
    func animateNewButtons()
    {
        let pos1 = ccp(-mPlayBtn.contentSize.width, mPlayBtn.position.y) as  CGPoint
        let move1  = CCActionMoveTo.actionWithDuration(0.5, position:pos1) as! CCActionMoveTo
        mPlayBtn.runAction(move1)
        
        let pos2 = ccp(SW+mTopScoreBtn.contentSize.width, mTopScoreBtn.position.y) as  CGPoint
        let move2  = CCActionMoveTo.actionWithDuration(0.5, position:pos2) as! CCActionMoveTo
        mTopScoreBtn.runAction(move2)
         
        let pos3 = ccp(-mMoreBtn.contentSize.width, mMoreBtn.position.y) as  CGPoint
        let move3  = CCActionMoveTo.actionWithDuration(0.5, position:pos3) as! CCActionMoveTo
        mMoreBtn.runAction(move3)
        
        let pos4 = ccp(SW*0.5, mKidsMode.position.y) as  CGPoint
        let move4  = CCActionMoveTo.actionWithDuration(0.7, position:pos4) as! CCActionMoveTo
        mKidsMode.runAction(move4)
            
        let pos5 = ccp(SW*0.5, mNormalMode.position.y) as  CGPoint
        let move5  = CCActionMoveTo.actionWithDuration(0.7, position:pos5) as! CCActionMoveTo
        mNormalMode.runAction(move5)
       
        let pos6 = ccp(SW*0.5, mExpertMode.position.y) as  CGPoint
        let move6  = CCActionMoveTo.actionWithDuration(0.7, position:pos6) as! CCActionMoveTo
        let calBck = CCActionCallBlock(block: ({
                        NSNotificationCenter.defaultCenter().postNotificationName("showFullScreenAds", object: nil)
                }))
        let array1:[AnyObject] = [move6,calBck]
        let seq1 = CCActionSequence.actionWithArray(array1) as! CCActionSequence
        mExpertMode.runAction(seq1)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
 
/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "Support/CCFileUtils.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"
#import "MyAdmob.h"


@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(initAds:) name:@"initAds" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(showFullScreenAds:) name:@"showFullScreenAds" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(showMoreGames:) name:@"showMoreGames" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(showAdmobBanner:) name:@"showAdmobBanner" object:nil];
    

    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isKidsModeUnlocked"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isKidsModeUnlocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isExpertModeUnlocked"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isExpertModeUnlocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
//    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
//    
//    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
//#ifdef APPORTABLE
//    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
//        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
//    else
//        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
//#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    srand (time(NULL));

     
    [self setupCocos2dWithOptions:@{
                                    CCSetupShowDebugStats: @(NO),
                                    CCSetupScreenOrientation: CCScreenOrientationPortrait,
                                    CCSetupPixelFormat: kEAGLColorFormatRGBA8,
                                    }];
    
    
    mInterstitial_ = [[GADInterstitial alloc] init];
    mInterstitial_.adUnitID = ADMOB_FULL_SCREEN;
    [mInterstitial_ loadRequest:[GADRequest request]];
    
    [[MyAdmob sharedAdmob] createAdmobAds];
    
    
    return YES;
}

 

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}


-(void)initAds:(NSNotification*)inNotif
{
    [ALSdk initializeSdk];
    
    [Chartboost startWithAppId:CHARTBOOST_ID appSignature:CHARTBOOST_SIG delegate:self];
    
    [self showFullScreenAds:nil];
    
    [Chartboost cacheMoreApps:CBLocationHomeScreen];
}


-(void)showAdmobBanner:(NSNotification *)notif
{
    [[MyAdmob sharedAdmob] showBannerView];
}



-(void)showFullScreenAds:(NSNotification *)notif
{
    static int index_987 = 0;
    
    index_987++;
    
    if(index_987 < 3)
    {
        [self showChartboostAds];
    }
    else
    {
        index_987 = 0;
        [self showAplovinAds];
    }
    
}




-(void)didDismissInterstitial:(CBLocation)location
{
    if([location isEqualToString:CBLocationHomeScreen])
    {
        [Chartboost cacheInterstitial:CBLocationMainMenu];
    }
    else if([location isEqualToString:CBLocationMainMenu])
    {
        [Chartboost cacheInterstitial:CBLocationGameOver];
    }
    else if([location isEqualToString:CBLocationGameOver])
    {
        [Chartboost cacheInterstitial:CBLocationLevelComplete];
    }
    else if([location isEqualToString:CBLocationLevelComplete])
    {
        [Chartboost cacheInterstitial:CBLocationHomeScreen];
    }
}

- (void)didDismissMoreApps:(CBLocation)location
{
    [Chartboost cacheMoreApps:CBLocationHomeScreen];
}

- (void)didClickInterstitial:(CBLocation)location
{
    //    int ran;
    //
    //    if(rand()%4!=0)
    //        ran = 1 + rand()%10 ;
    //    else if(rand()%4!=0)
    //        ran = 1 + rand()%50 ;
    //    else if(rand()%4!=0)
    //        ran = 1 + rand()%99 ;
    //
    //    [self submitAchievement:ACHIVEMENT_ID_8 percent:ran];
}


-(void)showChartboostAds
{
    static int cb_ads_index = 0;
    
    cb_ads_index++;
    
    if(cb_ads_index > 4)
        cb_ads_index = 1;
    
    switch (cb_ads_index)
    {
        case 1:
        {
            [Chartboost showInterstitial:CBLocationHomeScreen];
        }
            break;
        case 2:
        {
            [Chartboost showInterstitial:CBLocationMainMenu];
        }
            break;
        case 3:
        {
            [Chartboost showInterstitial:CBLocationGameOver];
        }
            break;
        case 4:
        {
            [Chartboost showInterstitial:CBLocationLevelComplete];
        }
            break;
            
        default:
        {
            [Chartboost showInterstitial:CBLocationGameOver];
        }
            break;
    }
}

-(void)showAplovinAds
{
    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
    
}


-(void)showMoreGames:(NSNotification *)notif
{
    [Chartboost showMoreApps:CBLocationHomeScreen];
}



- (void)didFailToLoadInterstitial:(CBLocation)location  withError:(CBLoadError)error
{
    static NSTimeInterval gCBLastFail = -999;
    static bool isFirssst = true;
    
    if(!isFirssst)
    {
        NSTimeInterval intr = [NSDate timeIntervalSinceReferenceDate];
        
        float diff = intr - gCBLastFail;
        
        if(diff < 4.0f)
        {
            return;
        }
        else
        {
            gCBLastFail = [NSDate timeIntervalSinceReferenceDate];
        }
    }
    
    gCBLastFail = [NSDate timeIntervalSinceReferenceDate];
    isFirssst = false;
    
    [self showAdmobInterstitial];
    
}


- (void)didFailToLoadInterstitial:(NSString *)location
{
    static NSTimeInterval gCBLastFail = -999;
    static bool isFirssst = true;
    
    if(!isFirssst)
    {
        NSTimeInterval intr = [NSDate timeIntervalSinceReferenceDate];
        
        float diff = intr - gCBLastFail;
        
        if(diff < 4.0f)
        {
            return;
        }
        else
        {
            gCBLastFail = [NSDate timeIntervalSinceReferenceDate];
        }
    }
    
    gCBLastFail = [NSDate timeIntervalSinceReferenceDate];
    isFirssst = false;
    
    [self showAdmobInterstitial];
    
}

-(void)showAdmobInterstitial
{
    [mInterstitial_ presentFromRootViewController:[CCDirector sharedDirector]];
    
    mInterstitial_ = nil;
    
    mInterstitial_ = [[GADInterstitial alloc] init];
    mInterstitial_.adUnitID = ADMOB_FULL_SCREEN;
    [mInterstitial_ loadRequest:[GADRequest request]];
}



@end

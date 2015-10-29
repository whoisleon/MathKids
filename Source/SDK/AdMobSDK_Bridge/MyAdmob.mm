//
//  MyAdmob.mm
//  The Four
//
//  Created by Gururaj T on 25/09/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MyAdmob.h"
#import "AppDelegate.h"

static MyAdmob *gBanner = nil;

@implementation MyAdmob

+(MyAdmob*)sharedAdmob
{
    if(!gBanner)
    {
        gBanner = [[MyAdmob alloc] init];
    }
    return gBanner;
}

-(void)createAdmobAds
{
    mBannerType = BANNER_TYPE;
    
    if(mBannerType <= kBanner_Portrait_Bottom)
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    else
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    
    mBannerView.adUnitID = ADMOB_BANNER_UNIT_ID;
    
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    
    mBannerView.rootViewController = [CCDirector sharedDirector];
    [[CCDirector sharedDirector].view addSubview:mBannerView];
    [mBannerView loadRequest:[GADRequest request]];
    
    // Initiate a generic request to load it with an ad.
    
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    CGRect frame = mBannerView.frame;
    
    off_x = 0.0f;
    on_x = 0.0f;
    
    switch (mBannerType)
    {
        case kBanner_Portrait_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Portrait_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
        case kBanner_Landscape_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Landscape_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    frame.origin.y = off_y;
    frame.origin.x = off_x;
    
    mBannerView.frame = frame;
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    
//    frame = mBannerView.frame;
//    frame.origin.x = on_x;
//    frame.origin.y = on_y;
//    
//    
//    mBannerView.frame = frame;
//    [UIView commitAnimations];
}

-(void)showBannerView
{
    if (mBannerView)
    {
        //banner on bottom
        {
            CGRect frame = mBannerView.frame;
            frame.origin.y = off_y;
            frame.origin.x = on_x;
            mBannerView.frame = frame;
            
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationCurveEaseOut
                             animations:^
             {
                 CGRect frame = mBannerView.frame;
                 frame.origin.y = on_y;
                 frame.origin.x = on_x;
                 
                 mBannerView.frame = frame;
             }
                             completion:^(BOOL finished)
             {
             }];
        }
        //Banner on top
        //        {
        //            CGRect frame = mBannerView.frame;
        //            frame.origin.y = -frame.size.height;
        //            frame.origin.x = off_x;
        //            mBannerView.frame = frame;
        //
        //            [UIView animateWithDuration:0.5
        //                                  delay:0.1
        //                                options: UIViewAnimationCurveEaseOut
        //                             animations:^
        //             {
        //                 CGRect frame = mBannerView.frame;
        //                 frame.origin.y = 0.0f;
        //                 frame.origin.x = off_x;
        //                 mBannerView.frame = frame;
        //             }
        //                             completion:^(BOOL finished)
        //             {
        //
        //
        //             }];
        //        }
        
    }
    
}


-(void)hideBannerView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = mBannerView.frame;
             frame.origin.y = off_y;
             frame.origin.x = off_x;
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             
             
         }];
    }
}


-(void)dismissAdView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGSize s = [[CCDirector sharedDirector] viewSize];
             
             CGRect frame = mBannerView.frame;
             frame.origin.y = frame.origin.y + frame.size.height ;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [mBannerView setDelegate:nil];
             [mBannerView removeFromSuperview];
             mBannerView = nil;
             
         }];
    }
    
}


@end

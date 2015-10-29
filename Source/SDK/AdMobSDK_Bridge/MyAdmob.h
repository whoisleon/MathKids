//
//  MyAdmob.h
//  The Four
//
//  Created by Gururaj T on 25/09/14.
//  Copyright (c) 2014 GururajT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>



typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

#define BANNER_TYPE kBanner_Portrait_Bottom

@interface MyAdmob : NSObject
{
    CocosBannerType mBannerType;
    GADBannerView *mBannerView;
    float on_x, on_y, off_x, off_y;

}
+(MyAdmob*)sharedAdmob;
-(void)createAdmobAds;
-(void)showBannerView;
-(void)hideBannerView;
@end

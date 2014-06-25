//
//  M2AppDelegate.h
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AdsRemoved @"AdsRemoved"
#import <AVFoundation/AVFoundation.h>


@interface M2AppDelegate : UIResponder <UIApplicationDelegate>
{
    AVAudioPlayer* player;
}

@property (strong, nonatomic) UIWindow *window;

+(BOOL)hadRemovedAds;

@end

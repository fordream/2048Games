//
//  M2AppDelegate.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AppDelegate.h"
#import "Appirater/Appirater.h"
#import "MKStoreManager.h"

@implementation M2AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef TAG_DELUXE
#else
    [MKStoreManager sharedManager];
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:AdsRemoved]) {
        [Appirater appLaunched];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(BOOL)hadRemovedAds{
    BOOL pRet = NO;
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"sss");
    }
    NSLog(@"ccc:%d",[[MKStoreManager sharedManager].purchasableObjects count]);
    if ([SKPaymentQueue canMakePayments] && [[MKStoreManager sharedManager].purchasableObjects count]) {
        SKProduct* product = [[MKStoreManager sharedManager].purchasableObjects objectAtIndex:0];
        
        if ([MKStoreManager isFeaturePurchased:product.productIdentifier]) {
            pRet = NO;
            NSLog(@"333");
        }
    }

    
    return pRet;
}

@end

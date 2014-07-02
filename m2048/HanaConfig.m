//
//  HanaConfig.m
//  Harbormania
//
//  Created by Yan Zhang on 3/15/09.
//  Copyright 2009 Hana Mobile LLC. All rights reserved.
//

#import "HanaConfig.h"
#import "DSUtility.h"
#import "SFHFKeychainUtils.h"

static HanaConfig *sharedConfig = nil;

@implementation HanaConfig

@synthesize musicOff;
@synthesize effectOff;
@synthesize notificationOff;
@synthesize launchedBefore;
@synthesize isProUpgradePurchased;
@synthesize useIPadAsset;
@synthesize lastLaunchDate;
@synthesize dailyGiftCounter;
@synthesize launchCount;
@synthesize showAdsOnActive, showDialogAds;
@synthesize isPaidUser;
@synthesize username, userid;

+ (HanaConfig *)sharedInstance {
    if (sharedConfig == nil) {
        sharedConfig = [[HanaConfig alloc] init];
    }
    
    return sharedConfig;
}

-(void)loadState{
	NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];

    self.useIPadAsset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
	self.launchedBefore = [userDefaults boolForKey:@"launchedBefore"];
    self.musicOff = [userDefaults boolForKey:@"musicOff"];
    self.effectOff = [userDefaults boolForKey:@"effectOff"];
    self.notificationOff = [userDefaults boolForKey:@"notificationOff"];
    self.useIPadAsset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    self.lastLaunchDate = [userDefaults objectForKey:@"lastLaunchDate"];
    self.dailyGiftCounter = [userDefaults integerForKey:@"dailyGiftCounter"];
    self.launchCount = [userDefaults integerForKey:@"launchCount"];
    self.showAdsOnActive = [userDefaults boolForKey:@"showAdsOnActive"];
    self.showDialogAds = [userDefaults boolForKey:@"showDialogAds"];
    self.isPaidUser = [userDefaults boolForKey:@"isPaidUser"];
    self.username = [userDefaults stringForKey:@"username"];
    self.userid = [[userDefaults objectForKey:@"userid"] longLongValue];
    
    if (!self.launchedBefore){
        self.musicOff = false;
        [userDefaults setBool:YES forKey:@"launchedBefore"];
        [userDefaults synchronize];
    }

	[userDefaults release];
}

-(void)saveState{
	NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
	 
    [userDefaults setBool:self.musicOff forKey:@"musicOff"];
    [userDefaults setBool:self.effectOff forKey:@"effectOff"];
    [userDefaults setBool:self.notificationOff forKey:@"notificationOff"];
    [userDefaults setObject:self.lastLaunchDate forKey:@"lastLaunchDate"];
    [userDefaults setInteger:self.dailyGiftCounter forKey:@"dailyGiftCounter"];
    [userDefaults setInteger:self.launchCount forKey:@"launchCount"];
    [userDefaults setBool:self.showAdsOnActive forKey:@"showAdsOnActive"];
    [userDefaults setBool:self.showDialogAds forKey:@"showDialogAds"];
    [userDefaults setBool:self.isPaidUser forKey:@"isPaidUser"];
    [userDefaults setObject:self.username forKey:@"username"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.userid] forKey:@"userid"];
    
	[userDefaults synchronize];
	[userDefaults release];
}

-(NSString *)getPassword4User:(NSString *)user{
    NSError *error = nil;
    if (user != nil && [user length] > 0){
        NSString *pwd = [SFHFKeychainUtils getPasswordForUsername:user 
                                                      andServiceName:@"EpicFighter" 
                                                               error:&error];
        return pwd;
    }
    return nil;
}

-(BOOL)setPassword4User:(NSString *)user password:(NSString *)password{
    NSError *error = nil;
    if (user != nil && [user length] > 0){
        [SFHFKeychainUtils storeUsername:user 
                             andPassword:password
                          forServiceName:@"EpicFighter"
                          updateExisting:YES 
                                   error:&error];
        return YES;
    }
    return NO;
}

-(BOOL)hasRegistered{
    if (self.username != nil && [self.username length] > 0){
        NSString *pwd = [self getPassword4User:self.username];
        if (pwd != nil && [pwd length] > 0){
            return YES;
        }
    }
    return NO;
}

-(BOOL)isReady2Play{
    return ([HanaConfig sharedInstance].userid > 0 && [DSUtility getCookie:@"zonemsg"] != nil);
}

-(BOOL)isAchievementEarned:(NSString*) identifier{
    // == 100 should be enough, just want to be safe
    // it should not introduce troubles
    return ([self getAchievementPercent:identifier] >= 100);
}

-(double)getAchievementPercent:(NSString*) identifier{
    NSString *achieveKey = [NSString stringWithFormat:@"AC_%@", identifier];
    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
    double percent = [userDefaults doubleForKey:achieveKey];
	[userDefaults release];
    return percent;
}

-(void)saveAchievement:(NSString*) identifier percentComplete:(double)percentComplete{
    NSString *achieveKey = [NSString stringWithFormat:@"AC_%@", identifier];
    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
    [userDefaults setDouble:percentComplete forKey:achieveKey];
	[userDefaults synchronize];
	[userDefaults release];
}

-(void)setInteger:(int)value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
    [userDefaults setInteger:value forKey:key];
	[userDefaults synchronize];
	[userDefaults release];
}

-(int)integerForKey:(NSString *)key{
    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
    int value = [userDefaults integerForKey:key];
	[userDefaults release];
    return value;
}

//-(void)setBool:(BOOL)value forKey:(NSString *)key{
//    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
//    [userDefaults setBool:value forKey:key];
//	[userDefaults synchronize];
//	[userDefaults release];
//}

//-(BOOL)boolForKey:(NSString *)key{
//    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] retain];
//    int value = [userDefaults integerForKey:key];
//	[userDefaults release];
//    return value;
//}


+(BOOL)isEnglishLocale{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return ([language caseInsensitiveCompare:@"en"] == NSOrderedSame);
}

+(BOOL)isChineseLocale{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return ([language hasPrefix:@"zh-"]);
}

@end

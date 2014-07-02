//
//  HanaConfig.h
//  Harbormania
//
//  Created by Yan Zhang on 3/15/09.
//  Copyright 2009 Hana Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HanaConfig : NSObject {
    bool launchedBefore;
    
    NSString *username;
    long long userid;
    
	BOOL musicOff;
    BOOL effectOff;
    BOOL notificationOff;
    NSDate *lastLaunchDate;
    int dailyGiftCounter;
    int launchCount;
    BOOL showAdsOnActive;
    BOOL showDialogAds;
    BOOL isPaidUser;
}

@property (nonatomic) bool launchedBefore;
@property (nonatomic) BOOL musicOff;
@property (nonatomic) BOOL effectOff;
@property (nonatomic) BOOL notificationOff;
@property (nonatomic) BOOL isProUpgradePurchased;
@property (nonatomic) BOOL useIPadAsset;
@property (nonatomic, retain) NSDate *lastLaunchDate;
@property (nonatomic) int dailyGiftCounter;
@property (nonatomic) int launchCount;
@property (nonatomic) BOOL showAdsOnActive;
@property (nonatomic) BOOL showDialogAds;
@property (nonatomic) BOOL isPaidUser;
@property (nonatomic, retain) NSString *username;
@property (nonatomic) long long userid;

+ (HanaConfig *)sharedInstance;

-(void)loadState;
-(void)saveState;

// helpers for local achivement
-(BOOL)isAchievementEarned:(NSString*) identifier;
-(double)getAchievementPercent:(NSString*) identifier;
-(void)saveAchievement:(NSString*) identifier percentComplete: (double) percentComplete;

-(void)setInteger:(int)value forKey:(NSString *)key;
-(int)integerForKey:(NSString *)key;
//-(void)setBool:(BOOL)value forKey:(NSString *)key;
//-(BOOL)boolForKey:(NSString *)key;

-(NSString *)getPassword4User:(NSString *)username;
-(BOOL)setPassword4User:(NSString *)username password:(NSString *)password;
-(BOOL)hasRegistered;
-(BOOL)isReady2Play;

+(BOOL)isEnglishLocale;
+(BOOL)isChineseLocale;

@end

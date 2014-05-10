//
//  M2ViewController.h
//  m2048
//

//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

@interface M2ViewController : UIViewController<ADBannerViewDelegate,GKGameCenterControllerDelegate>

@property (strong, nonatomic) ADBannerView *adView;
@property (strong, nonatomic)GameCenterManager* gameCenterManager;


- (void)updateScore:(NSInteger)score;

- (void)endGame:(BOOL)won;

+(void)showLeaderboard;

@end

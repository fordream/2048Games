//
//  M2ViewController.h
//  m2048
//

//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>


@interface M2ViewController : UIViewController<ADBannerViewDelegate>

@property (strong, nonatomic) ADBannerView *adView;


- (void)updateScore:(NSInteger)score;

- (void)endGame:(BOOL)won;

@end

//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2ViewController.h"
#import "M2SettingsViewController.h"
#import "MKStoreManager.h"
#import "M2AppDelegate.h"

#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"
#import "M2Overlay.h"
#import "M2GridView.h"

@implementation M2ViewController {
  IBOutlet UIButton *_restartButton;
  IBOutlet UIButton *_settingsButton;
  IBOutlet UILabel *_targetScore;
  IBOutlet UILabel *_subtitle;
  IBOutlet M2ScoreView *_scoreView;
  IBOutlet M2ScoreView *_bestView;
  
  M2Scene *_scene;
  
  IBOutlet M2Overlay *_overlay;
  IBOutlet UIImageView *_overlayBackground;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self updateState];
  
  _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
  
  _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
  _restartButton.layer.masksToBounds = YES;
  
  _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
  _settingsButton.layer.masksToBounds = YES;
  
  _overlay.hidden = YES;
  _overlayBackground.hidden = YES;

    
    
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  
  // Create and configure the scene.
  M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
  [self updateScore:0];
  [scene startNewGame];
  
  _scene = scene;
  _scene.delegate = self;
    
    //ADView
#ifdef TAG_IPAD
#else
    [self loadAdView];
#endif
}

-(BOOL)hadRemovedAds{
    BOOL pRet = NO;
NSLog(@"viewc:%ld", [[MKStoreManager sharedManager].purchasableObjects count]);
    if ([SKPaymentQueue canMakePayments] && [[MKStoreManager sharedManager].purchasableObjects count]) {
        SKProduct* product = [[MKStoreManager sharedManager].purchasableObjects objectAtIndex:0];
        
        if ([MKStoreManager isFeaturePurchased:product.productIdentifier]) {
            pRet = YES;
        }
    }

    
    return pRet;
}


- (void)updateState
{
  [_scoreView updateAppearance];
  [_bestView updateAppearance];
  
  _restartButton.backgroundColor = [GSTATE buttonColor];
  _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
  
  _settingsButton.backgroundColor = [GSTATE buttonColor];
  _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
  
  _targetScore.textColor = [GSTATE buttonColor];
  
  long target = [GSTATE valueForLevel:GSTATE.winningLevel];
  
  if (target > 100000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
  } else if (target < 10000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
  } else {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
  }
  
  _targetScore.text = [NSString stringWithFormat:@"%ld", target];
  
  _subtitle.textColor = [GSTATE buttonColor];
  _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
  _subtitle.text = [NSString stringWithFormat:NSLocalizedString(@"Join the numbers to get to %ld!", nil) , target];
  
  _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
  _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
  _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
  
  _overlay.message.textColor = [GSTATE buttonColor];
  [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
  [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    
//    if (DEVICE_IPAD) {
#ifdef DEVICE_IPAD
        
        _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14*2];
        
        _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14*2];
        
        if (target > 100000) {
            
            _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34*2];
        } else if (target < 10000) {
            _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42*2];
        } else {
            _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40*2];
        }
        
        _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14*2];
        
        _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36*2];
        _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17*2];
        _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17*2];
        
        _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36*2];
        _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17*2];
        _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17*2];
//    }
#endif
}


- (void)updateScore:(NSInteger)score
{
  _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  if ([Settings integerForKey:@"Best Score"] < score) {
    [Settings setInteger:score forKey:@"Best Score"];
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
  ((SKView *)self.view).paused = YES;
}


- (IBAction)restart:(id)sender
{
  [self hideOverlay];
  [self updateScore:0];
  [_scene startNewGame];
}


- (IBAction)keepPlaying:(id)sender
{
  [self hideOverlay];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
  ((SKView *)self.view).paused = NO;
  if (GSTATE.needRefresh) {
    [GSTATE loadGlobalState];
    [self updateState];
    [self updateScore:0];
    [_scene startNewGame];
  }
}


- (void)endGame:(BOOL)won
{
  _overlay.hidden = NO;
  _overlay.alpha = 0;
  _overlayBackground.hidden = NO;
  _overlayBackground.alpha = 0;
  
  if (!won) {
    _overlay.keepPlaying.hidden = YES;
    _overlay.message.text = NSLocalizedString( @"Game Over", nil);
  } else {
    _overlay.keepPlaying.hidden = NO;
    _overlay.message.text = NSLocalizedString(@"You Win!",nil);
  }
  
  // Fake the overlay background as a mask on the board.
  _overlayBackground.image = [M2GridView gridImageWithOverlay];
  
  // Center the overlay in the board.
  CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
  NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
  _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
  
  [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    _overlay.alpha = 1;
    _overlayBackground.alpha = 1;
  } completion:^(BOOL finished) {
    // Freeze the current game.
    ((SKView *)self.view).paused = YES;
  }];
}


- (void)hideOverlay
{
  ((SKView *)self.view).paused = NO;
  if (!_overlay.hidden) {
    [UIView animateWithDuration:0.5 animations:^{
      _overlay.alpha = 0;
      _overlayBackground.alpha = 0;
    } completion:^(BOOL finished) {
      _overlay.hidden = YES;
      _overlayBackground.hidden = YES;
    }];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

- (void)loadAdView{
    
#ifdef TAG_DELUXE
    //nothing added in deluxe
#else
    
    float adh = 52;
#ifdef DEVICE_IPAD
    adh = 71;
#endif
    
    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - adh, 0, 0);
    _adView = [[ADBannerView alloc] initWithFrame:rect];
	[self.view addSubview:_adView];
    [_adView setDelegate:self];
    _adView.hidden = YES;
#endif
}

//***ADView
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
#ifdef TAG_DELUXE
#else
	_adView.hidden = NO;
    if ([self hadRemovedAds]) {
        _adView.hidden = YES;
    }
#endif
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
#ifdef TAG_DELUXE
#else
//    NSLog(@"iad error:%@",error);
    _adView.hidden = YES;
    
    //remove this view and add again
    [_adView setDelegate:NULL];
    [_adView removeFromSuperview];

    [self loadAdView];
    
#endif
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{NSLog(@"did finish");}

//***gamecenter
+(void)showLeaderboard{
//    if ([GameCenterManager isGameCenterAvailable]) {
//        GKGameCenterViewController *gcController = [[GKGameCenterViewController alloc] init];
//        if (gcController != NULL)
//        {
//            //            leaderboardController.category = self.currentLeaderBoard;
//            gcController.viewState = GKGameCenterViewControllerStateLeaderboards;
//            gcController.gameCenterDelegate = self;
//        [self presentViewController:gcController animated:YES completion:nil];
//        }
//    }else{
//    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController NS_AVAILABLE_IOS(6_0){
}


@end

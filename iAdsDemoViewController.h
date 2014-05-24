//
//  iAdsDemoViewController.h
//  iAdsDemo
//
//  Created by gao wei on 10-6-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface iAdsDemoViewController : UIViewController 
<ADBannerViewDelegate> {
	ADBannerView *adView;
}

@end


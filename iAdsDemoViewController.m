//
//  iAdsDemoViewController.m
//  iAdsDemo
//
//  Created by gao wei on 10-6-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iAdsDemoViewController.h"



@implementation iAdsDemoViewController

- (void)viewDidLoad {
    //竖屏
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;

	[self.view addSubview:adView];
	adView.delegate = self;
	adView.hidden = YES;
		
	adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
	
    [super viewDidLoad];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	NSLog(@"should begin");
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	NSLog(@"did finish");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	NSLog(@"%d",adView.bannerLoaded);
	adView.hidden = NO;
	NSLog(@"did load");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"error:%@",error);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSLog(@"rotate");
	//adView.frame = CGRectZero;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		adView.currentContentSizeIdentifier =
		ADBannerContentSizeIdentifierLandscape;
		adView.frame = CGRectZero;
	}
    else
	{
        adView.currentContentSizeIdentifier =
		ADBannerContentSizeIdentifierPortrait;
		adView.frame = CGRectZero;
	}	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

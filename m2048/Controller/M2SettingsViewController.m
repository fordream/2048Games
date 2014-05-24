//
//  M2SettingsViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2SettingsViewController.h"
#import "M2SettingsDetailViewController.h"
#import "MKStoreManager.h"
#import "M2AppDelegate.h"

@interface M2SettingsViewController ()

@end


@implementation M2SettingsViewController {
  IBOutlet UITableView *_tableView;
  NSArray *_options;
  NSArray *_optionSelections;
  NSArray *_optionsNotes;

    //***
    NSArray* _optionsShow;
}


# pragma mark - Set up

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self commonInit];
  }
  return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}


- (void)commonInit
{
  _options = @[@"Game Type", @"Board Size", @"Theme"];
    _optionsShow = @[NSLocalizedString(@"Game Type", nil), NSLocalizedString(@"Board Size", nil), NSLocalizedString(@"Theme", nil)];
  
  _optionSelections = @[@[ NSLocalizedString(@"Powers of 2",nil), NSLocalizedString(@"Powers of 3",nil), NSLocalizedString(@"Fibonacci",nil)],
                        @[@"3 x 3", @"4 x 4", @"5 x 5"],
                        @[NSLocalizedString(@"Default",nil), NSLocalizedString(@"Vibrant",nil), NSLocalizedString(@"Joyful",nil)]];
  
  _optionsNotes = @[NSLocalizedString(@"For Fibonacci games, a tile can be joined with a tile that is one level above or below it, but not to one equal to it. For Powers of 3, you need 3 consecutive tiles to be the same to trigger a merge!",nil),
                    NSLocalizedString(@"The smaller the board is, the harder! For 5 x 5 board, two tiles will be added every round if you are playing Powers of 2.",nil),
                    NSLocalizedString(@"Choose your favorite appearance and get your own feeling of 2048! More (and higher quality) themes are in the works so check back regularly!",nil)];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Settings Detail Segue"]) {
    M2SettingsDetailViewController *sdvc = segue.destinationViewController;
    
    NSInteger index = [_tableView indexPathForSelectedRow].row;
    sdvc.title = [_options objectAtIndex:index];
    sdvc.options = [_optionSelections objectAtIndex:index];
    sdvc.footer = [_optionsNotes objectAtIndex:index];
  }
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger pRet;
#ifdef TAG_DELUXE
    pRet = 1;
#else
    if ([M2AppDelegate hadRemovedAds]) {
        pRet = 1;
    }else{
        pRet = 2;
    }
#endif
  return pRet;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return section ? 1 : _options.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  if (section) return @"";
  return NSLocalizedString(@"Please note: Changing the settings above would restart the game.", nil) ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Settings Cell"];
  
  if (indexPath.section) {
//    cell.textLabel.text = @"About 2048";
//    cell.detailTextLabel.text = @"";
      cell.textLabel.text = NSLocalizedString(@"Remove Ads",nil);
      
      cell.detailTextLabel.text = @"";
  } else {
//    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
      //***
      cell.textLabel.text = [_optionsShow objectAtIndex:indexPath.row];
    
    NSInteger index = [Settings integerForKey:[_options objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [[_optionSelections objectAtIndex:indexPath.row] objectAtIndex:index];
    cell.detailTextLabel.textColor = [GSTATE scoreBoardColor];
  }

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section) {
      if([SKPaymentQueue canMakePayments] && ![M2AppDelegate hadRemovedAds] && [[MKStoreManager sharedManager].purchasableObjects count]) {

          UIAlertView *alertConnect = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connecting to App Store...", nil)
                                                          message:nil
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
          [alertConnect show];

          
          SKProduct* product = [[MKStoreManager sharedManager].purchasableObjects objectAtIndex:0];
          [[MKStoreManager sharedManager]
           buyFeature:product.productIdentifier
           onComplete:^(NSString* purchasedFeature, NSData*purchasedReceipt, NSArray* availableDownloads)
           {
               NSLog(@"Purchased: %@", purchasedFeature);
               [alertConnect dismissWithClickedButtonIndex:0 animated:YES];
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase Successful", nil)
                                                               message:NSLocalizedString(@"Thank you. You have successfully remove all Ads",nil)
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                     otherButtonTitles:nil];
               [alert show];
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AdsRemoved];
           }
           onCancelled:^
           {
               [alertConnect dismissWithClickedButtonIndex:0 animated:YES];
               NSLog(@"User Cancelled Transaction");
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase Failed",nil)
                                                               message:NSLocalizedString(@"Unfortunately you have cancelled your purchase of remove Ads. Please try again.",nil)
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                     otherButtonTitles:nil];
               [alert show];
           }
           ];

          [alertConnect dismissWithClickedButtonIndex:0 animated:YES];
      }else {
          UIAlertView *alertConnect = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connecting to App Store failed!", nil)
                                                                 message:NSLocalizedString(@"Please tray later!",nil)
                                                                delegate:nil
                                                       cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                       otherButtonTitles:nil];
          [alertConnect show];
      }
      
    
  } else {
    [self performSegueWithIdentifier:@"Settings Detail Segue" sender:nil];
  }
}

@end

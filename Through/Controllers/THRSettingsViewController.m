//
//  THRSettingsViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRSettingsViewController.h"
#import "THRDeveloperViewController.h"
#import "THRLoginViewController.h"
#import "iLink.h"

@interface THRSettingsViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (void)shareOnFacebook;
- (void)shareOnTwitter;
- (void)rateOnAppStore;
- (void)logOut;

@end

@implementation THRSettingsViewController

static NSString *cellIdentifier = @"THRSettingTableViewCell";

#pragma mark - Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier
                                               bundle:nil]
         forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

#pragma mark - Private Methods

- (void)shareOnFacebook
{
    SLComposeViewController *facebookStatus = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookStatus setInitialText:@"Check Through in the AppStore!"];
    [facebookStatus addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
    [self presentViewController:facebookStatus
                       animated:YES
                     completion:nil];
}

- (void)shareOnTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           if(granted) {
                                               NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                                               if ([accounts count] > 0) {
                                                   SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                   [tweetSheet setInitialText:@"Check Through in the AppStore!"];
                                                   [tweetSheet addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
                                                   [self presentViewController:tweetSheet
                                                                      animated:YES
                                                                    completion:nil];
                                               }
                                               else {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [TSMessage
                                                        showNotificationInViewController:self
                                                        title:@"Error"
                                                        subtitle:@"It seems that you don't have a Twitter account configured."
                                                        type:TSMessageNotificationTypeError
                                                        duration:3.0f
                                                        canBeDismissedByUser:YES];
                                                   });
                                               }
                                           }
                                       }];
}

- (void)rateOnAppStore
{
    [[iLink sharedInstance] iLinkOpenRatingsPageInAppStore];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return @"Services";
                case 1:
                    return @"Log out";
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0:
                    return @"Share this app on Facebook";
                case 1:
                    return @"Share this app on Twitter";
                case 2:
                    return @"Rate this app on App Store";
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0:
                    return @"Developer";
                case 1:
                    return @"Acknowledgments";
            }
            break;
        }
        case 3: {
            switch (indexPath.row) {
                case 0:
                    return @"Terms of service";
                case 1:
                    return @"Privacy policy";
            }
            break;
        }
    }
    return @"";
}

- (void)logOut
{
    [PFUser logOut];
    THRLoginViewController *loginViewController = [[THRLoginViewController alloc]
                                                   initWithNibName:nil
                                                   bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:loginViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 2;
        case 3:
            return 2;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"Social";
        case 2:
            return @"About";
        case 3:
            return @"Legal";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self titleForIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                case 1:
                    [self logOut];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [self shareOnFacebook];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
                case 1: {
                    [self shareOnTwitter];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
                case 2: {
                    [self rateOnAppStore];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    controller = [[THRDeveloperViewController alloc] initWithNibName:nil
                                                                              bundle:nil];
                    break;
                }
                case 1: {
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-Through-acknowledgements"
                                                                     ofType:@"plist"];
                    controller = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
                    break;
                }
            }
            break;
        }
        case 3: {
            switch (indexPath.row) {
                case 0:
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                case 1:
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
            }
            break;
        }
    }
    if (controller != nil) {
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

@end

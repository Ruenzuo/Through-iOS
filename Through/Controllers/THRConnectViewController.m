//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRConnectViewController.h"
#import "THRFeedViewController.h"

NSString * const THRUserDidDisconnectedServicesNotification = @"THRUserDidDisconnectedServicesNotification";
NSString * const THRUserDidConnectedServicesNotification = @"THRUserDidConnectedServicesNotification";

@interface THRConnectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIBarButtonItem *btnDone;

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (void)connectTwitter;
- (void)connectFacebook;
- (void)done:(id)sender;
- (void)disconnectTwitter;
- (void)disconnectFacebook;
- (void)refreshDoneButton;

@end

@implementation THRConnectViewController

static NSString *cellIdentifier = @"THRServiceTableViewCell";

#pragma mark - Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        self.shouldAllowDisconnect = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.shouldAllowDisconnect) {
        self.title = @"Services";
    } else {
        self.title = @"Connect";
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"THRServiceTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellIdentifier];
    if (!self.shouldAllowDisconnect) {
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"Done"]
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = btnDone;
        btnDone.enabled = NO;
        self.btnDone = btnDone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                     forIndexPath:indexPath];
    PFUser *currentUser = [PFUser currentUser];
    if (indexPath.row == 0) {
        if ([[currentUser objectForKey:@"isTwitterServiceConnected"] boolValue]) {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.row == 1) {
        if ([[currentUser objectForKey:@"isFacebookServiceConnected"] boolValue]) {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    tableViewCell.textLabel.text = [self titleForIndexPath:indexPath];
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    switch (indexPath.row) {
        case 0: {
            if (![[[PFUser currentUser] objectForKey:@"isTwitterServiceConnected"] boolValue]) {
                [self connectTwitter];
            } else if (self.shouldAllowDisconnect) {
                [self disconnectTwitter];
            }
            break;
        }
        case 1: {
            if (![[[PFUser currentUser] objectForKey:@"isFacebookServiceConnected"] boolValue]) {
                [self connectFacebook];
            } else if (self.shouldAllowDisconnect) {
                [self disconnectFacebook];
            }
            break;
        }
    }
}

#pragma mark - Private Methods

- (void)refreshDoneButton
{
    PFUser *currentUser = [PFUser currentUser];
    if ([[currentUser objectForKey:@"isTwitterServiceConnected"] boolValue] ||
        [[currentUser objectForKey:@"isFacebookServiceConnected"] boolValue]) {
        self.btnDone.enabled = YES;
    } else {
        self.btnDone.enabled = NO;
    }
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            return @"Twitter";
        case 1:
            return @"Facebook";
        default:
            return @"";
    }
}

- (void)disconnectTwitter
{
    @weakify(self);
    
    PFUser *user = [PFUser currentUser];
    [SVProgressHUD showWithStatus:@"Disconnecting"
                         maskType:SVProgressHUDMaskTypeBlack];
    [PFCloud
     callFunctionInBackground:@"disconnectTwitterForUser"
     withParameters:@{@"username": [user objectForKey:@"username"]}
     block:^(NSArray *results, NSError *error) {
         
         @strongify(self);
         
         if (error) {
             //TODO: Handle error.
         } else {
             [user setObject:[NSNumber numberWithBool:NO]
                      forKey:@"isTwitterServiceConnected"];
             [user saveInBackground];
             [self.tableView reloadData];
             [SVProgressHUD showSuccessWithStatus:@"Twitter account disconnected."];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:THRUserDidDisconnectedServicesNotification
              object:nil];
         }
     }];
}

- (void)disconnectFacebook
{
    @weakify(self);
    
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    PFUser *user = [PFUser currentUser];
    [SVProgressHUD showWithStatus:@"Disconnecting"
                         maskType:SVProgressHUDMaskTypeBlack];
    [PFCloud
     callFunctionInBackground:@"disconnectFacebookForUser"
     withParameters:@{@"username": [user objectForKey:@"username"]}
     block:^(NSArray *results, NSError *error) {
         
         @strongify(self);
         
         if (error) {
             //TODO: Handle error.
         } else {
             [user setObject:[NSNumber numberWithBool:NO]
                      forKey:@"isFacebookServiceConnected"];
             [user saveInBackground];
             [self.tableView reloadData];
             [SVProgressHUD showSuccessWithStatus:@"Facebook account disconnected."];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:THRUserDidDisconnectedServicesNotification
              object:nil];
         }
     }];
}

- (void)connectTwitter
{
    @weakify(self);
    
    [SimpleAuth
     authorize:@"twitter"
     completion:^(id responseObject, NSError *error) {
         
         @strongify(self);
         
         if (error) {
             //TODO: Handle error.
         } else {
             PFObject *twitterOAuth = [PFObject objectWithClassName:@"TwitterOAuth"];
             NSDictionary *credentials = [responseObject objectForKey:@"credentials"];
             NSDictionary *extra = [responseObject objectForKey:@"extra"];
             NSDictionary *raw_info = extra[@"raw_info"];
             [twitterOAuth setObject:credentials[@"secret"]
                              forKey:@"secret"];
             [twitterOAuth setObject:credentials[@"token"]
                              forKey:@"token"];
             [twitterOAuth setObject:raw_info[@"id"]
                              forKey:@"twitterUserID"];
             [twitterOAuth setObject:[PFUser currentUser]
                              forKey:@"user"];
             [SVProgressHUD showWithStatus:@"Connecting"
                                  maskType:SVProgressHUDMaskTypeBlack];
             [twitterOAuth saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     //TODO: Handle error.
                 } else {
                     PFUser *user = [PFUser currentUser];
                     [user setObject:[NSNumber numberWithBool:YES]
                              forKey:@"isTwitterServiceConnected"];
                     [user saveInBackground];
                     [SVProgressHUD dismiss];
                     [self refreshDoneButton];
                     [self.tableView reloadData];
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:THRUserDidConnectedServicesNotification
                      object:nil];
                 }
             }];
         }
    }];
}

- (void)connectFacebook
{
    @weakify(self);
    
    [FBSession
     openActiveSessionWithReadPermissions:@[]
     allowLoginUI:YES
     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
         
         @strongify(self);
         
         if (error) {
             //TODO: Handle error.
         } else {
             if (status == FBSessionStateClosed) {
                 return;
             }
             PFObject *facebookOAuth = [PFObject objectWithClassName:@"FacebookOAuth"];
             [facebookOAuth setObject:[[session accessTokenData] accessToken]
                               forKey:@"token"];
             [facebookOAuth setObject:[PFUser currentUser]
                               forKey:@"user"];
             [SVProgressHUD showWithStatus:@"Connecting"
                                  maskType:SVProgressHUDMaskTypeBlack];
             [facebookOAuth saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     //TODO: Handle error.
                 } else {
                     PFUser *user = [PFUser currentUser];
                     [user setObject:[NSNumber numberWithBool:YES]
                              forKey:@"isFacebookServiceConnected"];
                     [user saveInBackground];
                     [SVProgressHUD dismiss];
                     [self refreshDoneButton];
                     [self.tableView reloadData];
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:THRUserDidConnectedServicesNotification
                      object:nil];
                 }
             }];
         }

     }];
    
}

- (void)done:(id)sender
{
    PFUser *user = [PFUser currentUser];
    [SVProgressHUD showWithStatus:@"Getting feed"
                         maskType:SVProgressHUDMaskTypeBlack];
    [PFCloud
     callFunctionInBackground:@"generateFeedsForUser"
     withParameters:@{@"username": [user objectForKey:@"username"]}
     block:^(NSArray *results, NSError *error) {
         if (error) {
             //TODO: Handle error.
         } else {
             [SVProgressHUD dismiss];
             THRFeedViewController *feedViewController = [[THRFeedViewController alloc]
                                                          initWithNibName:nil
                                                          bundle:nil];
             [feedViewController.feed addObjectsFromArray:results];
             UINavigationController *navigationController = [[UINavigationController alloc]
                                                             initWithRootViewController:feedViewController];
             [self presentViewController:navigationController
                                animated:YES
                              completion:nil];
         }
     }];
}

@end

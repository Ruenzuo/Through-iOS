//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRConnectViewController.h"
#import "THRFeedViewController.h"

@interface THRConnectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign, getter = isTwitterConnected) BOOL twitterConnected;
@property (nonatomic, assign, getter = isFacebookConnected) BOOL facebookConnected;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIBarButtonItem *btnDone;

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (void)connectTwitter;
- (void)connectFacebook;
- (void)done:(id)sender;

@end

@implementation THRConnectViewController

static NSString *cellIdentifier = @"THRServiceTableViewCell";

#pragma mark - Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        self.title = @"Connect";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"THRServiceTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellIdentifier];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"Done"]
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = btnDone;
    btnDone.enabled = NO;
    self.btnDone = btnDone;
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
    if (indexPath.row == 0) {
        if (self.isTwitterConnected) {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.row == 1) {
        if (self.isFacebookConnected) {
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
            if (![[PFUser currentUser] objectForKey:@"twitterOAuth"]) {
                [self connectTwitter];
            }
            break;
        }
        case 1: {
            if (![[PFUser currentUser] objectForKey:@"facebookOAuth"]) {
                [self connectFacebook];
            }
            break;
        }
    }
}

#pragma mark - Private Methods

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
                     self.twitterConnected = YES;
                     self.btnDone.enabled = YES;
                     [self.tableView reloadData];
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
                     self.facebookConnected = YES;
                     self.btnDone.enabled = YES;
                     [self.tableView reloadData];
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

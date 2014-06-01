//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRConnectViewController.h"
#import "THRFeedViewController.h"
#import "THRApiManager.h"

@interface THRConnectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign, getter = isTwitterConnected) BOOL twitterConnected;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIBarButtonItem *btnDone;
@property (nonatomic, strong) NSArray *twitterFeed;

- (void)connectTwitter;
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
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                     forIndexPath:indexPath];
    if (indexPath.row == 0 && self.isTwitterConnected) {
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    switch (indexPath.row) {
        case 0:
            [self connectTwitter];
            break;
    }
}

#pragma mark - Public Methods

- (void)connectTwitter
{
    @weakify(self);
    
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : kTwitterOAuthConsumerKey,
                                             @"consumer_secret" : kTwitterOAuthConsumerSecret
                                            };
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
             [twitterOAuth saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     //TODO: Handle error.
                 } else {
                     PFUser *user = [PFUser currentUser];
                     [user setObject:[NSNumber numberWithBool:YES]
                              forKey:@"hasServiceConnected"];
                     [user saveInBackground];
                     [PFCloud
                      callFunctionInBackground:@"generateFeedsForUser"
                      withParameters:@{@"username": [user objectForKey:@"username"]}
                      block:^(NSArray *results, NSError *error) {
                          if (error) {
                              //TODO: Handle error.
                          } else {
                              self.twitterConnected = YES;
                              self.btnDone.enabled = YES;
                              self.twitterFeed = results;
                              [self.tableView reloadData];
                          }
                      }];
                 }
             }];
         }
    }];
}

- (void)done:(id)sender
{
    THRFeedViewController *feedViewController = [[THRFeedViewController alloc]
                                                 initWithNibName:nil
                                                 bundle:nil];
    feedViewController.feed = self.twitterFeed;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:feedViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

@end

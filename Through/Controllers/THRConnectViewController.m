//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRConnectViewController.h"
#import "THRApiManager.h"

@interface THRConnectViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnNext;

- (void)connectTwitter;

@end

@implementation THRConnectViewController

#pragma mark - Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btnNext.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self connectTwitter];
            break;
        case 1:
            [self connectFacebook];
            break;
        case 2:
            [self connectInstagram];
            break;
    }
}

#pragma mark - Public Methods

- (void)connectTwitter
{
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : kTwitterOAuthConsumerKey,
                                             @"consumer_secret" : kTwitterOAuthConsumerSecret
                                            };
    [SimpleAuth
     authorize:@"twitter"
     completion:^(id responseObject, NSError *error) {
         if (error) {
             //TODO: Handle error.
         } else {
             PFObject *twitterOAuth = [PFObject objectWithClassName:@"TwitterOAuth"];
             NSDictionary *credentials = [responseObject objectForKey:@"credentials"];
             [twitterOAuth setObject:credentials[@"secret"] forKey:@"secret"];
             [twitterOAuth setObject:credentials[@"token"] forKey:@"token"];
             [twitterOAuth setObject:[PFUser currentUser] forKey:@"user"];
             [twitterOAuth saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     NSLog(@"%@", [error localizedDescription]);
                 } else {
                     NSLog(@"Succeed");
                 }
             }];
         }
    }];
}

- (void)connectFacebook
{
    
}

- (void)connectInstagram
{
    
}

@end

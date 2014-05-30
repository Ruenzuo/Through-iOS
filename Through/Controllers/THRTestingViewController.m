//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRTestingViewController.h"
#import "THRApiManager.h"

@interface THRTestingViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *twitterAccounts;

- (void)getAccessTokenForAccount:(ACAccount *)account;
- (void)askForAccounts;
- (void)chooseAccount;

@end

@implementation THRTestingViewController

#pragma mark - Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)getAccessTokenForAccount:(ACAccount *)account
{
    [[THRAPIManager sharedManager]
     reverseAuthTwitterForAccount:account
     withCompletionBlock:^(id object, NSError *error) {
         NSString *responseStr = [[NSString alloc] initWithData:object
                                                       encoding:NSUTF8StringEncoding];
         NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
         NSString *lined = [parts componentsJoinedByString:@"\n"];
         NSLog(@"%@", lined);
     }];
}

- (void)askForAccounts
{
    ACAccountType *twitterType = [self.accountStore
                                  accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    [self.accountStore
     requestAccessToAccountsWithType:twitterType
     options:nil
     completion:^(BOOL granted, NSError *error) {
         if (granted && !error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                 [self chooseAccount];
             });
         } else {
             //TODO: Handle error.
         }
     }];
}

- (void)chooseAccount
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Choose an Account"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    for (ACAccount *account in self.twitterAccounts) {
        [sheet addButtonWithTitle:account.username];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    [sheet showInView:self.view];
}

#pragma mark - Public Methods

- (IBAction)testReverseAuth:(id)sender
{
    [self askForAccounts];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == actionSheet.cancelButtonIndex) {
        [self getAccessTokenForAccount:self.twitterAccounts[buttonIndex]];
    }
}

@end

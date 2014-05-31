//
//  THRTestingViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRTestingViewController.h"
#import "THRApiManager.h"

@interface THRTestingViewController ()

@end

@implementation THRTestingViewController

#pragma mark - Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
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

#pragma mark - Public Methods

- (IBAction)testReverseAuth:(id)sender
{
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : kTwitterOAuthConsumerKey,
                                             @"consumer_secret" : kTwitterOAuthConsumerSecret
                                            };
    [SimpleAuth authorize:@"twitter"
               completion:^(id responseObject, NSError *error) {
                   NSLog(@"%@", responseObject);
    }];
}

@end

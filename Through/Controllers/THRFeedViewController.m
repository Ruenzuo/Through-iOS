//
//  THRFeedsViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 01/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRFeedViewController.h"

@interface THRFeedViewController ()

@end

@implementation THRFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Feed";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.feed) {
        PFQuery *query = [PFQuery queryWithClassName:@"TwitterMedia"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                //TODO: Handle error.
            } else {
                self.feed = objects;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

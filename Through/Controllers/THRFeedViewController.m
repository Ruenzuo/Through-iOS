//
//  THRFeedsViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 01/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRFeedViewController.h"

@interface THRFeedViewController ()

- (void)refresh:(id)sender;

@end

@implementation THRFeedViewController

#pragma mark - Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Feed";
        self.feed = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                target:self
                                action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = btnDone;
    if ([self.feed count] == 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"TwitterMedia"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query orderByDescending:@"mediaDate"];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                //TODO: Handle error.
            } else {
                [self.feed insertObjects:objects
                               atIndexes:[NSIndexSet
                                          indexSetWithIndexesInRange:
                                          NSMakeRange(0, [objects count])]];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)refresh:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"TwitterMedia"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    if ([self.feed count] != 0) {
        PFObject *lastFeed = self.feed[0];
        [query whereKey:@"mediaDate" greaterThan:[lastFeed objectForKey:@"mediaDate"]];
    }
    [query orderByDescending:@"mediaDate"];
    [query setLimit:50];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //TODO: Handle error.
        } else {
            [self.feed insertObjects:objects
                           atIndexes:[NSIndexSet
                                      indexSetWithIndexesInRange:
                                      NSMakeRange(0, [objects count])]];
        }
    }];
}

@end

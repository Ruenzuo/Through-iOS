//
//  THRPrivacyPolicyViewController.m
//  Through
//
//  Created by Renzo Crisostomo on 09/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRPrivacyPolicyViewController.h"

@interface THRPrivacyPolicyViewController ()

@end

@implementation THRPrivacyPolicyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setValue:[NSURL URLWithString:@"https://www.iubenda.com/privacy-policy/895941"]
                forKey:@"URL"];
    }
    return self;
}

@end

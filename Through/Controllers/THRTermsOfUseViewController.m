//
//  THRTermsOfUseViewController.m
//  Through
//
//  Created by Renzo Crisostomo on 09/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRTermsOfUseViewController.h"

@interface THRTermsOfUseViewController ()

@end

@implementation THRTermsOfUseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setValue:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/12352209/Through/ThroughToS.html"]
                forKey:@"URL"];
    }
    return self;
}

@end

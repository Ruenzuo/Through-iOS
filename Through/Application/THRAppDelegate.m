//
//  THRAppDelegate.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRAppDelegate.h"

@interface THRAppDelegate ()

- (void)setupParseWithLaunchOptions:(NSDictionary *)launchOptions;

@end

@implementation THRAppDelegate

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupParseWithLaunchOptions:launchOptions];
    return YES;
}

#pragma mark -

- (void)setupParseWithLaunchOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"13M9oMhAklF3jK9XjjVZ8cHa4qOwQZqYFM6CiXLL"
                  clientKey:@"o5A6XY0VXa7I1RggWh0kTKnZ31zHLzHLeTd2odJV"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

@end

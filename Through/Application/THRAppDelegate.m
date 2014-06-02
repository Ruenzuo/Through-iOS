//
//  THRAppDelegate.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRAppDelegate.h"
#import "THRLoginViewController.h"
#import "THRFeedViewController.h"
#import "THRConnectViewController.h"

@interface THRAppDelegate ()

- (void)setupParseWithLaunchOptions:(NSDictionary *)launchOptions;

@end

@implementation THRAppDelegate

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor colorWithHexString:@"#C644FC"];
    [self.window makeKeyAndVisible];
    [self setupParseWithLaunchOptions:launchOptions];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        THRLoginViewController *loginViewController = [[THRLoginViewController alloc]
                                                       initWithNibName:nil
                                                       bundle:nil];
        self.viewController = loginViewController;
    } else {
        if (![[user objectForKey:@"hasServiceConnected"] boolValue]) {
            THRConnectViewController *connectViewController = [[THRConnectViewController alloc]
                                                               initWithNibName:nil
                                                               bundle:nil];
            self.viewController = connectViewController;
        } else {
            THRFeedViewController *feedViewController = [[THRFeedViewController alloc]
                                                         initWithNibName:nil
                                                         bundle:nil];
            self.viewController = feedViewController;
        }
    }
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:self.viewController];
    self.window.rootViewController = navigationController;
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

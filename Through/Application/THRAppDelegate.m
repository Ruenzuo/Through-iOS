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
- (void)configureHockeyApp;
- (void)configureOAuth;
- (void)configureGoogleAnalytics;

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
    [self configureHockeyApp];
    [self configureOAuth];
    [self configureGoogleAnalytics];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        THRLoginViewController *loginViewController = [[THRLoginViewController alloc]
                                                       initWithNibName:nil
                                                       bundle:nil];
        self.viewController = loginViewController;
    } else {
        if (![[user objectForKey:@"isFacebookServiceConnected"] boolValue] &&
            ![[user objectForKey:@"isTwitterServiceConnected"] boolValue]) {
            THRConnectViewController *connectViewController = [[THRConnectViewController alloc]
                                                               initWithNibName:nil
                                                               bundle:nil];
            connectViewController.shouldAllowDisconnect = NO;
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if( [[[BITHockeyManager sharedHockeyManager] authenticator] handleOpenURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation]) {
        return YES;
    }
    BOOL wasHandled = [FBAppCall handleOpenURL:url
                             sourceApplication:sourceApplication];
    return wasHandled;
}

#pragma mark - Private Methods

- (void)setupParseWithLaunchOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"13M9oMhAklF3jK9XjjVZ8cHa4qOwQZqYFM6CiXLL"
                  clientKey:@"o5A6XY0VXa7I1RggWh0kTKnZ31zHLzHLeTd2odJV"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)configureHockeyApp
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppID];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

- (void)configureOAuth
{
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : kTwitterOAuthConsumerKey,
                                             @"consumer_secret" : kTwitterOAuthConsumerSecret
                                            };
}

- (void)configureGoogleAnalytics
{
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID];
}

@end

//
//  THRAPIManager.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRAPIManager.h"
#import "THRNetworkingHelper.h"

@interface THRAPIManager ()

@property (nonatomic, strong) THRNetworkingHelper *networkingHelper;

@end

@implementation THRAPIManager

#pragma mark - Lazy Loading

- (THRNetworkingHelper *)networkingHelper
{
    if (_networkingHelper == nil) {
        _networkingHelper = [[THRNetworkingHelper alloc] init];
    }
    return _networkingHelper;
}

#pragma mark - Public Methods

+ (THRAPIManager *)sharedManager
{
    static THRAPIManager *_sharedManager;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)reverseAuthTwitterForAccount:(ACAccount *)account
                 withCompletionBlock:(ObjectCompletionBlock)completionBlock;
{
    [[self networkingHelper] getTwitterRequestToken:^(id object, NSError *error) {
        if (error) {
            completionBlock(nil, error);
        } else {
            [[self networkingHelper] getTwitterAccessTokenForAccount:account
                                               withAuthorizationData:object
                                                     completionBlock:^(id object, NSError *error) {
                                                         completionBlock(object, error);
                                                     }];
        }
    }];
}

@end

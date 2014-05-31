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

@end

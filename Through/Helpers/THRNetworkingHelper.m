//
//  THRNetworkingHelper.m
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

@import Social;
#import "THRNetworkingHelper.h"
#import "OAuthCore.h"
#import "TWSignedRequest.h"

@interface THRNetworkingHelper ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation THRNetworkingHelper

#pragma mark - Private Methods

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

#pragma mark - Public Methods

- (void)getTwitterRequestToken:(ObjectCompletionBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    NSDictionary *params = @{@"x_auth_mode": @"reverse_auth"};
    TWSignedRequest *step1Request = [[TWSignedRequest alloc]
                                     initWithURL:url
                                     parameters:params
                                     requestMethod:TWSignedRequestMethodPOST];
    [step1Request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionBlock(data, error);
    }];
}

- (void)getTwitterAccessTokenForAccount:(ACAccount *)account
                  withAuthorizationData:(NSData *)authorizationData
                        completionBlock:(ObjectCompletionBlock)completionBlock;
{
    NSString *signedReverseAuthSignature = [[NSString alloc] initWithData:authorizationData
                                                                 encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"x_reverse_auth_target": [TWSignedRequest consumerKey],
                                  @"x_reverse_auth_parameters": signedReverseAuthSignature};
    NSURL *authTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    SLRequest *step2Request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodPOST
                                                           URL:authTokenURL
                                                    parameters:params];
    [step2Request setAccount:account];
    [step2Request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        completionBlock(responseData, error);
    }];
}

@end

//
//  THRNetworkingHelper.h
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THRNetworkingHelper : NSObject

- (void)getTwitterRequestToken:(ObjectCompletionBlock)completionBlock;
- (void)getTwitterAccessTokenForAccount:(ACAccount *)account
                  withAuthorizationData:(NSData *)authorizationData
                        completionBlock:(ObjectCompletionBlock)completionBlock;

@end

//
//  THRTestingViewController.h
//  Through
//
//  Created by Renzo Crisóstomo on 30/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const THRUserDidDisconnectedServicesNotification;
extern NSString * const THRUserDidConnectedServicesNotification;

@interface THRConnectViewController : GAITrackedViewController

@property (nonatomic, assign) BOOL shouldAllowDisconnect;

@end

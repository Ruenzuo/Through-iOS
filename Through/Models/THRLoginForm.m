//
//  THRLoginForm.m
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRLoginForm.h"

@implementation THRLoginForm

- (NSArray *)extraFields
{
    return @[
             @{
                 FXFormFieldTitle: @"Sign in",
                 FXFormFieldHeader: @"",
                 FXFormFieldAction: @"signIn"
                 }
             ];
}

@end

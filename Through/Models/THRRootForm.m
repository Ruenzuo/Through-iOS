//
//  THRRootForm.m
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRRootForm.h"

@implementation THRRootForm

- (NSDictionary *)loginFormField
{
    return @{
             FXFormFieldHeader: @"",
             FXFormFieldInline: @YES
             };
}

- (NSDictionary *)registrationFormField
{
    return @{
             FXFormFieldHeader: @"Not yet an user?",
             FXFormFieldTitle: @"Sign up"
             };
}

@end

//
//  THRRegistrationForm.m
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRRegistrationForm.h"

@implementation THRRegistrationForm

- (NSArray *)fields
{
    return @[
             @"email",
             @"password",
             @"repeatPassword",
             @{FXFormFieldKey: @"privacyPolicy", FXFormFieldHeader: @"Legal"},
             @"termsOfUse",
             @"agreedToTerms",
             @{FXFormFieldTitle: @"Create an account", FXFormFieldHeader: @"", FXFormFieldAction: @"signUp"}
             ];
}

@end

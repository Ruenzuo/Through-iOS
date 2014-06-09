//
//  THRRegistrationForm.h
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THRPrivacyPolicyViewController;
@class THRTermsOfUseViewController;

@interface THRRegistrationForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repeatPassword;
@property (nonatomic, readonly) THRPrivacyPolicyViewController *privacyPolicy;
@property (nonatomic, readonly) THRTermsOfUseViewController *termsOfUse;
@property (nonatomic, assign) BOOL agreedToTerms;

@end

//
//  THRRootForm.h
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRLoginForm.h"
#import "THRRegistrationForm.h"

@interface THRRootForm : NSObject <FXForm>

@property (nonatomic, strong) THRLoginForm *loginForm;
@property (nonatomic, strong) THRRegistrationForm *registrationForm;

@end

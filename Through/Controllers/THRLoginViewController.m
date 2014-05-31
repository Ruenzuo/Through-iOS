//
//  THRLoginViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRLoginViewController.h"
#import "THRRootForm.h"

@interface THRLoginViewController ()

- (BOOL)validateSignUpEmail;
- (BOOL)validateSignUpPassword;
- (void)showUnexpectedError;

@end

@implementation THRLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.formController.form = [[THRRootForm alloc] init];
    }
    return self;
}

#pragma mark - Private Methods

- (BOOL)validateSignUpEmail
{
    THRRootForm *form = self.formController.form;
    if ([form.registrationForm.email isMatch:RX(@"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)validateSignUpPassword
{
    THRRootForm *form = self.formController.form;
    if ([form.registrationForm.password isMatch:RX(@"^(?=.*\\d).{6,20}$")] &&
        [form.registrationForm.password isEqualToString:form.registrationForm.repeatPassword]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showUnexpectedError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Login error"
                              message:@"Unexpected error. Please try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Form Actions

- (void)signIn
{
    THRLoginForm *form = ((THRRootForm *) self.formController.form).loginForm;
    [PFUser
     logInWithUsernameInBackground:form.email
     password:form.password
     block:^(PFUser *user, NSError *error) {
         if (error) {
             if ([error code] == 201) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Login error"
                                          message:@"Invalid user info."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                 [alertView show];
             } else {
                 [self showUnexpectedError];
             }
         } else {
             [self performSegueWithIdentifier:@"ConnectSegue"
                                       sender:self];
         }
     }];
}

- (void)signUp
{
    THRRegistrationForm *form = ((THRRootForm *) self.formController.form).registrationForm;
    if ([self validateSignUpEmail] &&
        [self validateSignUpPassword]) {
        PFUser *user = [PFUser user];
        user.username = form.email;
        user.password = form.password;
        user.email = form.email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self showUnexpectedError];
            } else {
                [self performSegueWithIdentifier:@"ConnectSegue"
                                          sender:self];
            }
        }];
    }
}

@end

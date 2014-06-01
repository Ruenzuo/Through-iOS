//
//  THRLoginViewController.m
//  Through
//
//  Created by Renzo Crisóstomo on 31/05/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRLoginViewController.h"
#import "THRRootForm.h"
#import "THRConnectViewController.h"
#import "THRFeedViewController.h"

@interface THRLoginViewController ()

- (BOOL)validateSignInFields;
- (BOOL)validateSignUpEmail;
- (BOOL)validateSignUpPassword;
- (void)showInvalidUserInfoError;
- (void)showUnexpectedError;
- (void)showConnectViewController;
- (void)showFeedViewController;

@end

@implementation THRLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        self.formController.form = [[THRRootForm alloc] init];
        self.title = @"Through";
    }
    return self;
}

#pragma mark - Private Methods

- (BOOL)validateSignInFields
{
    THRRootForm *form = self.formController.form;
    if ([form.loginForm.email length] == 0) {
        return NO;
    } else if ([[form.loginForm.email
                 stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                length] == 0) {
        return NO;
    } else if ([form.loginForm.password length] == 0) {
        return NO;
    } else if ([[form.loginForm.password stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                length] == 0) {
        return NO;
    } else {
        return YES;
    }
}

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

- (void)showInvalidUserInfoError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Login error"
                              message:@"Invalid user info."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
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

- (void)showConnectViewController
{
    THRConnectViewController *connectViewController = [[THRConnectViewController alloc]
                                                       initWithNibName:nil
                                                       bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:connectViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)showFeedViewController
{
    THRFeedViewController *feedViewController = [[THRFeedViewController alloc]
                                                 initWithNibName:nil
                                                 bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:feedViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

#pragma mark - Form Actions

- (void)signIn
{
    @weakify(self);
    
    if (![self validateSignInFields]) {
        [self showInvalidUserInfoError];
    } else {
        THRLoginForm *form = ((THRRootForm *) self.formController.form).loginForm;
        [PFUser
         logInWithUsernameInBackground:form.email
         password:form.password
         block:^(PFUser *user, NSError *error) {
             
             @strongify(self);
             
             if (error) {
                 if ([error code] == 101) {
                     [self showInvalidUserInfoError];
                 } else {
                     [self showUnexpectedError];
                 }
             } else {
                 if (![[user objectForKey:@"hasServiceConnected"] boolValue]) {
                     [self showConnectViewController];
                 } else {
                     [self showFeedViewController];
                 }
             }
         }];
    }
}

- (void)signUp
{
    @weakify(self);
    
    THRRegistrationForm *form = ((THRRootForm *) self.formController.form).registrationForm;
    if ([self validateSignUpEmail] &&
        [self validateSignUpPassword]) {
        PFUser *user = [PFUser user];
        user.username = form.email;
        user.password = form.password;
        user.email = form.email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            @strongify(self);
            
            if (error) {
                [self showUnexpectedError];
            } else {
                [self showConnectViewController];
            }
        }];
    }
}

@end

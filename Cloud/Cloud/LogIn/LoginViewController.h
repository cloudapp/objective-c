//
//  LoginViewController.h
//  Cloudier
//
//  Created by Benjamin Mayo on 05/10/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginMenuEmailPasswordView.h"
#import <SafariServices/SafariServices.h>

typedef void(^LoginViewControllerAnimationCompletionBlock)();

typedef enum {
    LoginViewControllerStateSplash,
    LoginViewControllerStateLogin,
    LoginViewControllerStateExitTransition,
} LoginViewControllerState;

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewController:(LoginViewController *)controller didFinishWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)loginViewControllerDidPerformRequestToRegister:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController {
    
}

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;

- (LoginMenuEmailPasswordView *)emailPasswordView;

- (void)showLoginScreen;
- (void)flashLogo;

- (void)pulseLoginButtonNumberOfTimes:(int)numberOfTimes;
- (void)pulseLoginButtonOnce;

- (void)fadeOutWithCompletionHandler:(LoginViewControllerAnimationCompletionBlock)completionHandler;

- (BOOL)loading;
- (void)setLoading:(BOOL)loading;

- (BOOL)clearsPasswordOnDisplay;
- (void)setClearsPasswordOnDisplay:(BOOL)clearsPasswordOnDisplay;

@end

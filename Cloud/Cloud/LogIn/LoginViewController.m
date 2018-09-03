//
//  LoginViewController.m
//  Cloudier
//
//  Created by Benjamin Mayo on 05/10/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "UIColor+AdditionalColors.h"
#import "CLApiEngine.h"
#import "LoginViewController.h"
#import "ExternalAuthViewController.h"

//#import "SignUpViewController.h"
//
//#import "CloudAppTitleLabel.h"
//#import "BezeledDarkGrayButton.h"
//#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginViewController (){//}<GIDSignInUIDelegate>{
    UIView *_mainContentView;
    UIImageView *_cloudLogoImageView;
    LoginMenuEmailPasswordView *_emailPasswordView;
    UIButton *_loginButton;
    UIButton *_signupButton;
    UIButton *_googleSigInButton;
    LoginViewControllerState _state;
    UIColor *activatedTextColor;
    BOOL _clearPasswordOnDisplay;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [GIDSignIn sharedInstance].uiDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    activatedTextColor = [UIColor colorWithRed:92/255.0f green:98/255.0f blue:103/255.0f alpha:1.0];

    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.clearsPasswordOnDisplay = YES;
    
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mainContentView];
        
    _cloudLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cloud-MainLogo"]];
    [_mainContentView addSubview:_cloudLogoImageView];
        
    _emailPasswordView = [[LoginMenuEmailPasswordView alloc] initWithFrame:CGRectZero];
    
    [_mainContentView insertSubview:_emailPasswordView belowSubview:_cloudLogoImageView];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 84, 64)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00]];
    [_loginButton.layer setCornerRadius:64/2];
    
    [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginButton setTitle:@"Sign in with email" forState:UIControlStateNormal];
    [_loginButton setTitle:@"Loading ..." forState:UIControlStateDisabled];
    
    [_mainContentView addSubview:_loginButton];
    
    _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _signupButton.frame = CGRectMake(0, 0, CGRectGetWidth(_loginButton.frame), 24);
    
    
    _googleSigInButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_googleSigInButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    _googleSigInButton.layer.borderWidth = 1;
    [_googleSigInButton setTitle:@"Sign in with Google" forState:UIControlStateNormal];
    _googleSigInButton.layer.borderColor = [[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00] CGColor];
    [_googleSigInButton setTitleColor:[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00] forState:UIControlStateNormal];
    _googleSigInButton.layer.cornerRadius = 32;
    //[_googleSigInButton setImage:[UIImage imageNamed:@"googleLogo"] forState:UIControlStateNormal];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 20, 0, 40);
    [_googleSigInButton setImageEdgeInsets:inset];
    [_googleSigInButton addTarget:self action:@selector(sigInWithGoogle) forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_googleSigInButton];
    [NSLayoutConstraint activateConstraints: @[
                                               [_googleSigInButton.leadingAnchor constraintEqualToAnchor:_mainContentView.leadingAnchor constant:42],
                                                [_googleSigInButton.trailingAnchor constraintEqualToAnchor:_mainContentView.trailingAnchor constant:-42],
                                               [_googleSigInButton.topAnchor constraintEqualToAnchor:_mainContentView.topAnchor constant:434],
                                               [_googleSigInButton.heightAnchor constraintEqualToConstant:64]
                                               ]];
    
    
    
    NSString *prefixToMessage = @"Don't have an account? \n";
    NSString *suffixToMessage = @"Sign up.";
    NSString *message = [prefixToMessage stringByAppendingString:suffixToMessage];
    
    NSRange totalMessageRange = NSMakeRange(0, message.length);
    NSRange linkMessageRange = NSMakeRange(prefixToMessage.length, suffixToMessage.length);
    
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:message];
    
    [linkString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightLight] range:totalMessageRange];
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:totalMessageRange];
    
    [linkString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightLight] range:linkMessageRange];
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00] range:linkMessageRange];
    
    NSMutableAttributedString *highlightedLinkString = linkString.mutableCopy;
    
    [highlightedLinkString addAttribute:NSForegroundColorAttributeName value:activatedTextColor range:totalMessageRange];
    [highlightedLinkString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:linkMessageRange];
    _signupButton.titleLabel.numberOfLines = 0;
    _signupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_signupButton setAttributedTitle:linkString forState:UIControlStateNormal];
    [_signupButton setAttributedTitle:highlightedLinkString forState:UIControlStateHighlighted];
    
    [_signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainContentView addSubview:_signupButton];
    
    [self setAppearanceForState:LoginViewControllerStateLogin animated:YES completionHandler:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordTextFieldDidReturn) name:LoginMenuEmailPasswordViewPasswordFieldDidReturn object:_emailPasswordView];
}
- (void)sigInWithGoogle {
   // [[GIDSignIn sharedInstance] signIn];
    ExternalAuthViewController *externalVC = [[ExternalAuthViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:externalVC animated:YES completion:^{
       
    }];
    
}
- (LoginViewControllerState)state {
    return _state;
}

- (void)setAppearanceForState:(LoginViewControllerState)state animated:(BOOL)animated completionHandler:(LoginViewControllerAnimationCompletionBlock)completionHandler {
    _state = state;
    
    _cloudLogoImageView.alpha = 1;
    
    CGFloat totalYOffsetForImageView = 40;
    
    CGPoint centerForCloudLogoImageView = CGPointZero;
    
    if (state == LoginViewControllerStateSplash) {
        centerForCloudLogoImageView = CGPointMake(CGRectGetMidX(_mainContentView.bounds), CGRectGetMidY(_mainContentView.bounds));
    } else if (state == LoginViewControllerStateLogin) {
        centerForCloudLogoImageView = CGPointMake(CGRectGetMidX(_mainContentView.bounds),(CGRectGetHeight(_cloudLogoImageView.frame) / 2) - 20 + totalYOffsetForImageView + 50);
    } else if (state == LoginViewControllerStateExitTransition) {
        centerForCloudLogoImageView = _cloudLogoImageView.center;
    }
    
    CGFloat anchorYPointForEmailPasswordView = centerForCloudLogoImageView.y;
    _emailPasswordView.center = CGPointMake(CGRectGetMidX(self.view.bounds), anchorYPointForEmailPasswordView + (CGRectGetHeight(_cloudLogoImageView.frame) / 2) + (CGRectGetHeight(_emailPasswordView.frame) / 2) + 168);
    _emailPasswordView.frame = CGRectIntegral(_emailPasswordView.frame);
    
    _loginButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), _emailPasswordView.center.y + ((CGRectGetHeight(_loginButton.frame) / 2) + (CGRectGetHeight(_emailPasswordView.frame) / 2)) + 30);
    _loginButton.frame = CGRectIntegral(_loginButton.frame);
    
    _signupButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.view.frame.size.height - 80);

    _signupButton.frame = CGRectIntegral(_signupButton.frame);
    _signupButton.alpha = 0;
    _googleSigInButton.alpha = 0;
    
    CGFloat targetAlpha = (state == LoginViewControllerStateLogin) ? 1 : 0;

    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
          _emailPasswordView.alpha = _loginButton.alpha = _signupButton.alpha = _googleSigInButton.alpha = targetAlpha;
            
            if (state == LoginViewControllerStateExitTransition) {
                _cloudLogoImageView.alpha = 0;
            } else {
                _cloudLogoImageView.center = CGPointMake(centerForCloudLogoImageView.x, centerForCloudLogoImageView.y - 10);
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _cloudLogoImageView.center = centerForCloudLogoImageView;
                _cloudLogoImageView.frame = CGRectIntegral(_cloudLogoImageView.frame);
            
                if (completionHandler) {
                    completionHandler();
                }
            }];
        }];
            
    } else {
       _emailPasswordView.alpha = _loginButton.alpha = targetAlpha;
        _cloudLogoImageView.center = centerForCloudLogoImageView;
        _cloudLogoImageView.frame = CGRectIntegral(_cloudLogoImageView.frame);
    }
}

- (LoginMenuEmailPasswordView *)emailPasswordView {
    if (!_emailPasswordView) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return _emailPasswordView;
}

- (BOOL)loading {
    return !_loginButton.enabled;
}

- (void)setLoading:(BOOL)loading {
    _loginButton.enabled = !loading;
}

- (BOOL)clearsPasswordOnDisplay {
    return _clearPasswordOnDisplay;
}

- (void)setClearsPasswordOnDisplay:(BOOL)clearPasswordOnDisplay {
    _clearPasswordOnDisplay = clearPasswordOnDisplay;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.clearsPasswordOnDisplay) {
        self.emailPasswordView.passwordFieldText = @"";
    } else {
        self.clearsPasswordOnDisplay = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        _mainContentView.transform = CGAffineTransformMakeTranslation(0, (keyboardFrame.size.height - CGRectGetMaxY(_emailPasswordView.frame)));
        _signupButton.alpha = 0;
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        _mainContentView.transform = CGAffineTransformIdentity;
        _signupButton.alpha = 1;
    } completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    
    if (touch.view == self.view || touch.view == _mainContentView) {
        [_emailPasswordView resignFirstResponder];
    }
}

- (void)loginButtonPressed:(UIButton *)loginButton {
    

    [self.emailPasswordView resignFirstResponder];

    if (self.emailPasswordView.emailFieldText.length > 0 && self.emailPasswordView.passwordFieldText.length > 0) {
        //[self.delegate loginViewController:self didFinishWithEmail:self.emailPasswordView.emailFieldText andPassword:self.emailPasswordView.passwordFieldText];
    } else {
        [self performSelector:@selector(flashLogo) withObject:nil afterDelay:0.5];
    }
}

- (void)passwordTextFieldDidReturn {
    
    [self loginButtonPressed:nil];
}

- (void)showLoginScreen {
    [self setAppearanceForState:LoginViewControllerStateLogin animated:YES completionHandler:nil];
}

- (void)flashLogo {
    if ([_cloudLogoImageView.layer animationForKey:@"jitter"]) {
        [_cloudLogoImageView.layer removeAnimationForKey:@"jitter"];
    }
    
    _cloudLogoImageView.layer.transform = CATransform3DIdentity;
    
    CAKeyframeAnimation *jitterAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    jitterAnimation.values = @[
        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]
    ];
    
    jitterAnimation.autoreverses = YES;
    jitterAnimation.repeatCount = 2.0f;
    jitterAnimation.duration = 0.08f;
    jitterAnimation.removedOnCompletion = YES;
    
    [_cloudLogoImageView.layer addAnimation:jitterAnimation forKey:@"jitter"];
}

- (void)fadeOutWithCompletionHandler:(LoginViewControllerAnimationCompletionBlock)completionHandler {
    [self setAppearanceForState:LoginViewControllerStateExitTransition animated:YES completionHandler:completionHandler];
}

- (void)signupButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate loginViewControllerDidPerformRequestToRegister:self];
}

- (void)pulseLoginButtonOnce {
    [self pulseLoginButtonNumberOfTimes:1];
}

- (void)pulseLoginButtonNumberOfTimes:(int)num {
    CGFloat totalTimeForOnePulse = 0.95;
    
    CAKeyframeAnimation *pulseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    pulseAnimation.values = @[
        [NSValue valueWithCATransform3D:CATransform3DIdentity],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.025, 1.04, 1)],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.93, 1)],
    ];
    
    pulseAnimation.keyTimes = @[@(0.4), @(0.9), @(1)];
    pulseAnimation.repeatCount = num;
    pulseAnimation.duration = totalTimeForOnePulse;
    pulseAnimation.removedOnCompletion = YES;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //pulseAnimation.timingFunctions = @[];
    
    [_loginButton.layer addAnimation:pulseAnimation forKey:@"pulse"];
}

#pragma mark Google button delegates

//-(void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//
//}
//
//-(void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//
//-(void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end

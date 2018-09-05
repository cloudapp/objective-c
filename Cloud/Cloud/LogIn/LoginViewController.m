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

@interface LoginViewController ()<ExternalAuthViewControllerDelegate, CLAPIEngineInternalDelegate>{//}<GIDSignInUIDelegate>{
    UIView *_mainContentView;
    UIImageView *_cloudLogoImageView;
    LoginMenuEmailPasswordView *_emailPasswordView;
    UIButton *_loginButton;
    UIButton *_signupButton;
    UIButton *_googleSigInButton;
    LoginViewControllerState _state;
    UIColor *activatedTextColor;
    BOOL _clearPasswordOnDisplay;
    UINavigationBar *navigationBar;
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
    navigationBar = [self addNavigationBar];

    [_mainContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints: @[
                                               [_mainContentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                               [_mainContentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                               [_mainContentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                               [_mainContentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],                                               ]];
    
    
    _cloudLogoImageView = [[UIImageView alloc] initWithImage:[self cloudAppImage]];
    [_cloudLogoImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_cloudLogoImageView setFrame:CGRectMake(0, 30, 100, 100)];
    [_mainContentView addSubview:_cloudLogoImageView];
        
    _emailPasswordView = [[LoginMenuEmailPasswordView alloc] initWithFrame:CGRectZero];
    
    [_mainContentView insertSubview:_emailPasswordView belowSubview:_cloudLogoImageView];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 84, 25)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00]];
    [_loginButton.layer setCornerRadius:50/2];
    
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
    [_googleSigInButton setTitle:@"Loading ..." forState:UIControlStateDisabled];

    _googleSigInButton.layer.borderColor = [[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00] CGColor];
    [_googleSigInButton setTitleColor:[UIColor colorWithRed:0.36 green:0.52 blue:0.90 alpha:1.00] forState:UIControlStateNormal];
    _googleSigInButton.layer.cornerRadius = 25;
    [_googleSigInButton setImage:[self googleImage] forState:UIControlStateNormal];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 20, 0, 40);
    [_googleSigInButton setImageEdgeInsets:inset];
    [_googleSigInButton addTarget:self action:@selector(sigInWithGoogle) forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_googleSigInButton];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [_googleSigInButton.centerXAnchor constraintEqualToAnchor:_mainContentView.centerXAnchor],
                                              
                                              [_googleSigInButton.topAnchor constraintEqualToAnchor:_loginButton.bottomAnchor constant:8],
                                              [_googleSigInButton.widthAnchor constraintEqualToConstant:300],
                                              [_googleSigInButton.heightAnchor constraintEqualToConstant:50],
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
    
   // [_mainContentView addSubview:_signupButton];
    
    [self setAppearanceForState:LoginViewControllerStateLogin animated:YES completionHandler:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordTextFieldDidReturn) name:LoginMenuEmailPasswordViewPasswordFieldDidReturn object:_emailPasswordView];

}

- (UINavigationBar*)addNavigationBar {
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectZero];
    //[UINavigationBar appearance].barTintColor = [UIColor lightGrayColor];
    //[UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [myNav setTranslatesAutoresizingMaskIntoConstraints:NO];
    myNav.barTintColor = [UIColor whiteColor];
    [self.view addSubview:myNav];
    
    
    [NSLayoutConstraint activateConstraints:@[
                                              [myNav.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [myNav.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [myNav.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor]
                                              ]];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(closeViewController)];
    
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Login for CloudApp"];
    // navigItem.rightBarButtonItem = doneItem;
    navigItem.leftBarButtonItem = cancelItem;
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
    
    [UIBarButtonItem appearance].tintColor = [UIColor blueColor];
    
    return  myNav;
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sigInWithGoogle {
   // [[GIDSignIn sharedInstance] signIn];
    ExternalAuthViewController *externalVC = [[ExternalAuthViewController alloc] initWithNibName:nil bundle:nil];
    externalVC.delegate = self;
    [self presentViewController:externalVC animated:YES completion:^{
       
    }];
    
}
- (LoginViewControllerState)state {
    return _state;
}

- (void)setAppearanceForState:(LoginViewControllerState)state animated:(BOOL)animated completionHandler:(LoginViewControllerAnimationCompletionBlock)completionHandler {
    _state = state;
    
    _cloudLogoImageView.alpha = 1;
    
    [_emailPasswordView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [_emailPasswordView.centerXAnchor constraintEqualToAnchor:_mainContentView.centerXAnchor],
                                              
                                              [_emailPasswordView.topAnchor constraintEqualToAnchor:_cloudLogoImageView.bottomAnchor constant:10],
                                              [_emailPasswordView.widthAnchor constraintEqualToConstant:300],
                                              [_emailPasswordView.heightAnchor constraintEqualToConstant:100],
                                              ]];
    
    
    
    [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [_loginButton.centerXAnchor constraintEqualToAnchor:_mainContentView.centerXAnchor],
                                              
                                              [_loginButton.topAnchor constraintEqualToAnchor:_emailPasswordView.bottomAnchor constant:8],
                                              [_loginButton.widthAnchor constraintEqualToConstant:300],
                                              [_loginButton.heightAnchor constraintEqualToConstant:50],
                                              ]];
    
    _signupButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.view.frame.size.height - 80);

    _signupButton.frame = CGRectIntegral(_signupButton.frame);
    _signupButton.alpha = 0;
    _googleSigInButton.alpha = 0;
    
    CGFloat targetAlpha = (state == LoginViewControllerStateLogin) ? 1 : 0;
    _emailPasswordView.alpha = _loginButton.alpha = _signupButton.alpha = _googleSigInButton.alpha = targetAlpha;
    [_cloudLogoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [_cloudLogoImageView.centerXAnchor constraintEqualToAnchor:_mainContentView.centerXAnchor],
                                              
                                              [_cloudLogoImageView.topAnchor constraintEqualToAnchor:navigationBar.bottomAnchor constant:8],
                                              [_cloudLogoImageView.widthAnchor constraintEqualToConstant:300],
                                              [_cloudLogoImageView.heightAnchor constraintEqualToConstant:100],
                                              ]];
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
    //UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_mainContentView.transform = CGAffineTransformMakeTranslation(0, (keyboardFrame.size.height - CGRectGetMaxY(self->_emailPasswordView.frame)));
        self->_signupButton.alpha = 0;
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_mainContentView.transform = CGAffineTransformIdentity;
        self->_signupButton.alpha = 1;
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
        [CLAPIEngine shared].internaldelegate = self;
        [CLAPIEngine shared].email = self.emailPasswordView.emailFieldText;
        [CLAPIEngine shared].password = self.emailPasswordView.passwordFieldText;
        
        [[CLAPIEngine shared] getAccountToken:@"getAccountToken"];
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

-(void)didLoginWithToken:(NSString *)token {
    [_googleSigInButton setEnabled:false];
    [CLAPIEngine shared].internaldelegate = self;
    [[CLAPIEngine shared] getJWTfromToken:token and:nil];
}

-(void)tokenWith:(NSString *)tokenString and:(NSString *)connectionIdentifier {
    NSLog(@"token getted: %@", tokenString);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage*) cloudAppImage {
    NSURL *url = [NSURL URLWithString:@"data:image/png;base64,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"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    return [UIImage imageWithData:imageData];
}



-(UIImage*) googleImage{
    NSURL *url = [NSURL URLWithString:@"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAAA3tJREFUOBGdlGtIU2Ecxt/33HZ12lpatFpqygjL+pBS0nWFECoRId2jwoxuRPWhe0ZFRpcPgYEZUhBFfigiqg9dbBVqFg43s8tippbTM5uam7ucnfO2Se84O027nC//5/88z/tjG+8OBCM8qKaG9PS0HxLc7iLB1ZMhsE4VZGQAMAwHk7Ruekr6M3r8hHJZ8brWeAgYzxy8cPoy19S4JdTdxcTLsQcJAsnyFlgT5pgKYX5+J/YjMwY8VF09KWBrqOOsFr249CdN6saF5PNN21U79lXhLoUFulmV0lf75F3IYU/A3t9OFOIhIGG3uB8FD9TXW+NBCYUS0Vkz7FCT1AIosh95PZn8187s0BfH8Acgx2h5eX5hkapk58PfwIPnT1X6Ht1LFgcRzeTOtSYapplgaWmvNBs8e+IwZ289wOTOWxGGPpbmECEEeXOBd6DSo+DZoWguW7jkVuLRM2uixr8K9GnfLu4JjTjzZPTjWAFiTbNR367Nbf/KkfYpYejTtmGTcwLlAhYwxmUCcmWulxYj+9U6pCUDYNQr+Oucn0L+DgOGIMQDKvWzn1pz5xX2xLOhxd/ucPFqsRdPZ0wg+ggQ7JWLQyifGHNtxBkSL6Nojx8oCABJSV+yjgIYKQpygCIAlRQUF5C/a7x4/x+tVsAABRWGDuR9b4wABIIBFaHF8iu2g3O3Tl9dJ4XmptMbZqeRWqkf/r9Wuj0CiX0lA9wUkKfdDxtGlk4HR3xLgY3tJOYIuuthLwMX8dxqou5ijWfF42CJGBrxDTqiiSBkM4+9Vq/yb/yeA2z9XcP9eqdl6vHXl27jwyPNqlqkb2rjL0pztQyWEzB1k99M5l3rD3pj8gdt5uK9L8vryxor4v7mJ99cXtLS09HcJrl+2QayfftSpiH62ix5erTb4mpNiaGHFw2jFozatI+JMo2VhuQPL+ebzPp6Z713O5LVtApk8qXgsz17+BhDQ7Q+j1m4No9+EQVXNd/Qm7ub333oc2ik8D/tOZoCYLeuRIuMzJlDy2WHI/0oOLLc/Hhf9/xbo62JbY379SOdeI+aUaIiffHFvTmF+3EeA8bmBUv1uedfG/c4va7o+xpn4gkhRNk6Y8+slKyiHVmr3sRk4kWsy2rLqMQxqbudHnZDp9dp8HEB5VDIRyYwqsBYedJAsmKsRa9OOb5t+uq34nNY/wTzJk+slO9WWwAAAABJRU5ErkJggg=="];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    return [UIImage imageWithData:imageData];
}
@end

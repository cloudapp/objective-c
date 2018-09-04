//
//  LoginMenuEmailPasswordView.m
//  Cloudier
//
//  Created by Benjamin Mayo on 03/11/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import "LoginMenuEmailPasswordView.h"


#import "CustomInsetTextField.h"

#define LOGIN_MENU_HEIGHT 94
#define LOGIN_MENU_WIDTH 252

NSString *LoginMenuEmailPasswordViewPasswordFieldDidReturn = @"LoginMenuEmailPasswordViewPasswordFieldDidReturn";

@interface LoginMenuEmailPasswordView () <UITextFieldDelegate> {
    UIImageView *_imageView;
    
    UITextField *_emailTextField;
    UITextField *_passwordTextField;
}

@end

@implementation LoginMenuEmailPasswordView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, LOGIN_MENU_WIDTH, LOGIN_MENU_HEIGHT)];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginCellsBackgroundImage"]];
        [self addSubview:_imageView];
        
        _emailTextField = [[CustomInsetTextField alloc] initWithFrame:CGRectZero];
        _emailTextField.placeholder = @"Email";
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _passwordTextField = [[CustomInsetTextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"Password";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _emailTextField.delegate = _passwordTextField.delegate = self;
        _emailTextField.contentVerticalAlignment = _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailTextField.clearButtonMode = _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.font = _passwordTextField.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _emailTextField.textColor = _passwordTextField.textColor = [UIColor colorWithRed:92/255.0f green:97/255.0f blue:103/255.0f alpha:1.0];
        [self addSubview:_emailTextField];
        [self addSubview:_passwordTextField];
        
        [self setupViews];
    }
    
    return self;
}
- (void)setupViews {
    
    [_emailTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
//    _emailTextField.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3] .CGColor;
//    _emailTextField.layer.borderWidth = 1;
//    _emailTextField.layer.cornerRadius = 4;
//    [_emailTextField.layer setMaskedCorners:(kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner)];
//
//    _passwordTextField.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3] .CGColor;
//    _passwordTextField.layer.borderWidth = 1;
//    _passwordTextField.layer.cornerRadius = 4;
//    [_passwordTextField.layer setMaskedCorners:(kCALayerMaxXMaxYCorner|kCALayerMinXMaxYCorner)];
}

#pragma mark - Getters and Setters

- (NSString *)emailFieldText {
    return _emailTextField.text;
}

- (void)setEmailFieldText:(NSString *)emailFieldText {
    _emailTextField.text = (emailFieldText.length > 0) ? emailFieldText : @"";
}

- (NSString *)passwordFieldText {
    return _passwordTextField.text;
}

- (void)setPasswordFieldText:(NSString *)passwordFieldText {
    _passwordTextField.text = passwordFieldText;
}

#pragma mark - Layout Management

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, LOGIN_MENU_WIDTH, LOGIN_MENU_HEIGHT)];
}

- (CGRect)rectForTextFieldAtIndex:(NSInteger)idx {
    CGFloat xOffset, yOffset, height, width;
    xOffset = 0;
    
    height = 45;
    
    width = self.frame.size.width - xOffset - 4;
    
    yOffset = 2 + (height * idx);
    
    return CGRectMake(xOffset, yOffset, width, height);
}

- (CGRect)rectForTextFieldImageAtIndex:(NSInteger)idx {
    CGFloat xOffset, yOffset, height, width;
    xOffset = 0;
    
    height = 45;
    
    width = 40 - 4;
    
    yOffset = 2 + (height * idx);
    
    return CGRectMake(xOffset, yOffset, width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.bounds = self.frame;
    
    _emailTextField.frame = CGRectOffset([self rectForTextFieldAtIndex:0], 0, 1);
    _passwordTextField.frame = [self rectForTextFieldAtIndex:1];
}

#pragma mark - Touch Handling 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint location = [touches.anyObject locationInView:self];
    
    for (int i = 0; i < 2; i++) {
        CGRect rectForTextFieldImage = [self rectForTextFieldImageAtIndex:i];
        
        if (CGRectContainsPoint(rectForTextFieldImage, location)) {
            if (i == 0) {
                [_emailTextField becomeFirstResponder];
            } else if (i == 1) {
                [_passwordTextField becomeFirstResponder];
            }
        }
    }
}

#pragma mark - Responder Handling

- (BOOL)becomeFirstResponder {
    BOOL become;
    
    if (!_emailTextField.hasText) {
        become = [_emailTextField becomeFirstResponder];
    } else if (!_passwordTextField.hasText) {
        become = [_passwordTextField becomeFirstResponder];
    } else {
        become = [_emailTextField becomeFirstResponder];
    }
    
    return become;
}

- (BOOL)resignFirstResponder {
    if (_emailTextField.isFirstResponder) {
        return [_emailTextField resignFirstResponder];
    } else if (_passwordTextField.isFirstResponder) {
        return [_passwordTextField resignFirstResponder];
    }
        
    return [super resignFirstResponder];
}

#pragma mark - Delegate Handling 

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _emailTextField && _passwordTextField.hasText) {
        _emailTextField.returnKeyType = UIReturnKeyDefault;
        
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailTextField && _emailTextField.returnKeyType == UIReturnKeyNext) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginMenuEmailPasswordViewPasswordFieldDidReturn object:self userInfo:nil];
    }
    
    return YES;
}

@end

//
//  LoginMenuEmailPasswordView.h
//  Cloudier
//
//  Created by Benjamin Mayo on 03/11/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+AdditionalColors.h"

extern NSString *LoginMenuEmailPasswordViewPasswordFieldDidReturn;

@interface LoginMenuEmailPasswordView : UIView {
    
}

- (NSString *)emailFieldText;
- (void)setEmailFieldText:(NSString *)emailFieldText;

- (NSString *)passwordFieldText;
- (void)setPasswordFieldText:(NSString *)passwordFieldText;

@end

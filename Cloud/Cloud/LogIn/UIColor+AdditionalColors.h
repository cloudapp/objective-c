//
//  UIColor+AdditionalColors.h
//  Cloudier
//
//  Created by Benjamin Mayo on 05/10/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AdditionalColors)

+ (UIColor *)primaryBackgroundColor;
+ (UIColor *)mainTextColor;

+ (UIColor *)cellTextColor;

+ (UIColor *)activatedTextColor;
+ (UIColor *)deactivatedTextColor;

+ (UIColor *)bodyTextColor;
+ (UIColor *)emphasisBodyTextColor;

+ (UIColor *)fullScreenViewDimmedBackgroundColor;

@end

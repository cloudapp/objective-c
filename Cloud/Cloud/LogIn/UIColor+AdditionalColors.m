//
//  UIColor+AdditionalColors.m
//  Cloudier
//
//  Created by Benjamin Mayo on 05/10/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import "UIColor+AdditionalColors.h"

@implementation UIColor (AdditionalColors)

+ (UIColor *)primaryBackgroundColor {
    static UIColor *primaryBackgroundColor;
    
    if (!primaryBackgroundColor) {
        primaryBackgroundColor = [UIColor colorWithRed:238/255.0f green:241/255.0f blue:245/255.0f alpha:1.0];
    }
    
    return primaryBackgroundColor;
}

+ (UIColor *)mainTextColor {
    static UIColor *mainTextColor;
    
    if (!mainTextColor) {
        mainTextColor = [UIColor colorWithRed:81/255.0f green:86/255.0f blue:90/255.0f alpha:1.0];
    }
    
    return mainTextColor;
}

+ (UIColor *)cellTextColor {
    static UIColor *cellTextColor;
    
    if (!cellTextColor) {
        cellTextColor = [UIColor colorWithRed:92/255.0f green:97/255.0f blue:103/255.0f alpha:1.0];
    }
    
    return cellTextColor;
}

+ (UIColor *)deactivatedTextColor {
    static UIColor *deactivatedTextColor;
    
    if (!deactivatedTextColor) {
        deactivatedTextColor = [UIColor colorWithRed:169/255.0f green:174/255.0f blue:178/255.0f alpha:1.0];
    }
    
    return deactivatedTextColor;
}

+ (UIColor *)activatedTextColor {
    static UIColor *activatedTextColor;
    
    if (!activatedTextColor) {
        activatedTextColor = [UIColor colorWithRed:92/255.0f green:98/255.0f blue:103/255.0f alpha:1.0];
    }
    
    return activatedTextColor;
}

+ (UIColor *)bodyTextColor {
    static UIColor *bodyTextColor;
    
    if (!bodyTextColor) {
        bodyTextColor = [UIColor colorWithRed:140/255.0f green:146/255.0f blue:150/255.0f alpha:1.0];
    }
    
    return bodyTextColor;
}

+ (UIColor *)emphasisBodyTextColor {
    static UIColor *emphasisBodyTextColor;
    
    if (!emphasisBodyTextColor) {
        emphasisBodyTextColor = [UIColor colorWithRed:80/255.0f green:85/255.0f blue:90/255.0f alpha:1.0];
    }
    
    return emphasisBodyTextColor;
}

+ (UIColor *)fullScreenViewDimmedBackgroundColor {
    static UIColor *fullScreenViewDimmedBackgroundColor;
    
    if (!fullScreenViewDimmedBackgroundColor) {
        fullScreenViewDimmedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    }
    
    return fullScreenViewDimmedBackgroundColor;
}

@end

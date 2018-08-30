//
//  CustomInsetLabel.m
//  Cloudier
//
//  Created by Benjamin Mayo on 04/11/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import "CustomInsetTextField.h"

@implementation CustomInsetTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectOffset([super clearButtonRectForBounds:bounds], -3, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], UIEdgeInsetsMake(0, 0, 0, 3));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  NSString+Substrings.h
//  Cloudier
//
//  Created by Benjamin Mayo on 09/02/2013.
//  Copyright (c) 2013 Benjamin Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substrings)

- (BOOL)containsSubstringInArray:(NSArray *)substrings;
- (BOOL)containsSubstringInArray:(NSArray *)substrings indexOfFirstFoundSubstring:(NSInteger *)idx;

@end

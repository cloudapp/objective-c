//
//  NSString+Substrings.m
//  Cloudier
//
//  Created by Benjamin Mayo on 09/02/2013.
//  Copyright (c) 2013 Benjamin Mayo. All rights reserved.
//

#import "NSString+Substrings.h"

@implementation NSString (Substrings)

- (BOOL)containsSubstringInArray:(NSArray *)substrings {
    return [self containsSubstringInArray:substrings indexOfFirstFoundSubstring:NULL];
}

- (BOOL)containsSubstringInArray:(NSArray *)substrings indexOfFirstFoundSubstring:(NSInteger *)idx {
    __block NSInteger foundIndex = NSNotFound;
    
    [substrings enumerateObjectsUsingBlock:^(NSString *substring, NSUInteger idx, BOOL *stop) {
        NSRange range = [self rangeOfString:substring];
        
        if (range.location != NSNotFound) {
            foundIndex = idx;
            
            *stop = YES;
        }
    }];
    
    if (idx != NULL) {
        *idx = foundIndex;
    }
    
    return foundIndex != NSNotFound;
}

@end

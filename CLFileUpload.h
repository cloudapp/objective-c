//
//  CLFileUpload.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUpload.h"

@interface CLFileUpload : CLUpload {
	NSData *data;
}

@property (copy, readwrite) NSData *data;

- (id)initWithName:(NSString *)theName data:(NSData *)theData;
+ (CLFileUpload *)fileUploadWithName:(NSString *)theName data:(NSData *)theData;

@end

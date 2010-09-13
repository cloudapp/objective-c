//
//  CLRedirectUpload.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUpload.h"

@interface CLRedirectUpload : CLUpload {
	NSURL *URL;
}

@property (retain, readwrite) NSURL *URL;

- (id)initWithName:(NSString *)theName URL:(NSURL *)theURL;
+ (CLRedirectUpload *)redirectUploadWithName:(NSString *)theName URL:(NSURL *)theURL;

@end

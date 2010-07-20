//
//  CLTextUpload.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLFileUpload.h"

@interface CLTextUpload : CLFileUpload {

}

@property (copy, readwrite) NSString *text;

- (id)initWithName:(NSString *)theName text:(NSString *)theText;
+ (CLTextUpload *)textUploadWithName:(NSString *)theName text:(NSString *)theText;

@end

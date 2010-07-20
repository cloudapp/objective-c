//
//  CLUpload.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLUpload : NSObject {

}

//This method should be implemented by subclasses
- (NSURLRequest *)requestForURL:(NSURL *)theURL;

@end

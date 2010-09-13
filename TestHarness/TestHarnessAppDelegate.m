//
//  TestHarnessAppDelegate.m
//  TestHarness
//
//  Created by Nick Paulson on 9/12/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "TestHarnessAppDelegate.h"
#import "CLAPIEngine.h"

@implementation TestHarnessAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	CLAPIEngine *engine = [CLAPIEngine engineWithDelegate:self];
	[engine setEmail:@"user@email.com"];
	[engine setPassword:@"password"];
	
	//File upload example
	/*	
	NSString *filePath = @"/Demo.mov";
	NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
	CLFileUpload *newUpload = [CLFileUpload fileUploadWithName:[filePath lastPathComponent] data:fileData];
	[engine doUpload:newUpload];
	*/
	
	//Recent items example
	[engine getRecentItemsStartingAtPage:1 count:5];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	NSLog(@"[ERROR] %@: %@", connectionIdentifier, error);
}

- (void)request:(NSString *)connectionIdentifier progressedToPercentage:(CGFloat)percentage {
	NSLog(@"[PROGRESS] %@: %f", connectionIdentifier, percentage);
}

- (void)recentItemsReceived:(NSArray *)recentItems forRequest:(NSString *)connectionIdentifier {
	NSLog(@"[SUCCESS] %@: %@", connectionIdentifier, recentItems);
}

@end

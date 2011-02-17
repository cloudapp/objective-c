//
//  TestHarnessAppDelegate.m
//  TestHarness
//
//  Created by Nick Paulson on 2/15/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "TestHarnessAppDelegate.h"
#import <Cloud.h>

@interface TestHarnessAppDelegate () <CLAPIEngineDelegate>

@end

@implementation TestHarnessAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	CLAPIEngine *engine = [CLAPIEngine engineWithDelegate:self];
	engine.email = @"user@email.com";
	engine.password = @"password";
	
	/*
	 --------Upload File--------
     NSString *fileLocation = [@"~/Desktop/SomeFile.txt" stringByExpandingTildeInPath];
     [engine uploadFileWithName:[fileLocation lastPathComponent] fileData:[NSData dataWithContentsOfFile:fileLocation] userInfo:@"Uploads rock!"];
	 */
	
	/*
	 --------Get Recent Items--------
     [engine getItemListStartingAtPage:1 itemsPerPage:5 userInfo:nil];
	 */
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[FAIL]: %@, %@", connectionIdentifier, error);
}

- (void)fileUploadDidProgress:(CGFloat)percentageComplete connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[UPLOAD PROGRESS]: %@, %f", connectionIdentifier, percentageComplete);
}

- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[UPLOAD SUCCESS]: %@, %@", connectionIdentifier, item);
}

- (void)itemListRetrievalSucceeded:(NSArray *)items connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[ITEM LIST]: %@, %@", connectionIdentifier, items);
}

@end

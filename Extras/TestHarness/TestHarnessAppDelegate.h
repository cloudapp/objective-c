//
//  TestHarnessAppDelegate.h
//  TestHarness
//
//  Created by Nick Paulson on 2/15/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TestHarnessAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end

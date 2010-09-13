//
//  TestHarnessAppDelegate.h
//  TestHarness
//
//  Created by Nick Paulson on 9/12/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CLAPIEngineDelegate.h"

@interface TestHarnessAppDelegate : NSObject <NSApplicationDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end

//
//  CLAPIEngineDelegate.h
//  Cloud
//
//  Created by Nick Paulson on 8/8/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLWebItem, CLUpload;
@protocol CLAPIEngineDelegate <NSObject>
@optional
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error;

//This method is only sent to the delegate when the connection is an upload
- (void)request:(NSString *)connectionIdentifier progressedToPercentage:(CGFloat)percentage;

- (void)recentItemsReceived:(NSArray *)recentItems forRequest:(NSString *)connectionIdentifier;
- (void)shortURLInformationReceived:(CLWebItem *)theItem forRequest:(NSString *)connectionIdentifier;
- (void)hrefDeleted:(NSURL *)theHref forRequest:(NSString *)connectionIdentifier;
- (void)uploadSucceeded:(CLUpload *)theUpload resultingItem:(CLWebItem *)theItem forRequest:(NSString *)connectionIdentifier;
@end

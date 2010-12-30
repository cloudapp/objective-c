//
//  CLAPISerializer.m
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPISerializer.h"


@implementation CLAPISerializer

+ (NSString *)webItemTypeStringForType:(CLWebItemType)theType {
	NSString *retString = nil;
	switch (theType) {
		case CLWebItemTypeArchive:
			retString = @"archive";
			break;
		case CLWebItemTypeAudio:
			retString = @"audio";
			break;
		case CLWebItemTypeVideo:
			retString = @"video";
			break;
		case CLWebItemTypeText:
			retString = @"text";
			break;
		case CLWebItemTypeBookmark:
			retString = @"bookmark";
			break;
		case CLWebItemTypeImage:
			retString = @"image";
			break;
		case CLWebItemTypeUnknown:
		default:
			retString = @"other";
			break;
	}
	return retString;
}

@end

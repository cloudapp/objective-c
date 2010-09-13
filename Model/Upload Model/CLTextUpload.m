//
//  CLTextUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLTextUpload.h"
#import "NSString+NPAdditions.h"

@implementation CLTextUpload
@dynamic text;

- (id)initWithName:(NSString *)theName text:(NSString *)theText {
	return [super initWithName:theName data:[theText dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (CLTextUpload *)textUploadWithName:(NSString *)theName text:(NSString *)theText {
	return [[[[self class] alloc] initWithName:theName text:theText] autorelease];
}

- (NSString *)name {
	if ([super name] == nil || [[super name] length] == 0) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
		[dateFormatter setDateFormat:nil];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		
		NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
		[dateFormatter release];
		
		NSMutableString *finalString = [NSMutableString stringWithString:[dateString stringByAppendingFormat:@" %@", timeString]];
		[finalString replaceOccurrencesOfString:@"/" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [finalString length])];
		[finalString replaceOccurrencesOfString:@":" withString:@"." options:NSLiteralSearch range:NSMakeRange(0, [finalString length])];
		[finalString appendString:@".txt"];
		
		return finalString;
	}
	return [super name];
}

- (NSString *)text {
	return [NSString stringWithData:self.data encoding:NSUTF8StringEncoding];
}

- (void)setText:(NSString *)newText {
	self.data = [newText dataUsingEncoding:NSUTF8StringEncoding];
}

@end

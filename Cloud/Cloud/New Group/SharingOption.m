//
//  SharingOption.m
//  Cloudier
//
//  Created by Benjamin Mayo on 01/11/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import "SharingOption.h"
#import <UIKit/UIKit.h>

NSString *const SharingOptionMail = @"Mail";
NSString *const SharingOptionFacebook = @"Facebook";
NSString *const SharingOptionTwitter = @"Twitter";
NSString *const SharingOptionCopyLink = @"Copy Link";
NSString *const SharingOptionSaveImage = @"Save Image";
NSString *const SharingOptionCopyImage = @"Copy Image";
NSString *const SharingOptionRename = @"Rename";

@interface SharingOption () {
    
}

@end

@implementation SharingOption

+ (SharingOption *)sharingOptionWithTitle:(NSString *)title andImage:(UIImage *)image {
    SharingOption *option = [[SharingOption alloc] initWithTitle:title andImage:image];
    
    return option;
}

+ (SharingOption *)sharingOptionWithTitle:(NSString *)title andImageIdentifier:(NSString *)imageIdentifier {
    NSString *imageName = [imageIdentifier stringByAppendingString:@"-SharingOption"];
    
    SharingOption *option = [[SharingOption alloc] initWithTitle:title andImage:[UIImage imageNamed:imageName]];
    option.highlightedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"active"]];
    
    return option;
}

- (id)initWithTitle:(NSString *)title andImage:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.image = image;
    }
    
    return self;
}

@end

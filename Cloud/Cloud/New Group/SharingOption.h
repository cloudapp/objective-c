//
//  SharingOption.h
//  Cloudier
//
//  Created by Benjamin Mayo on 01/11/2012.
//  Copyright (c) 2012 Benjamin Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const SharingOptionMail;
extern NSString *const SharingOptionFacebook;
extern NSString *const SharingOptionTwitter;
extern NSString *const SharingOptionCopyLink;
extern NSString *const SharingOptionSaveImage;
extern NSString *const SharingOptionCopyImage;
extern NSString *const SharingOptionRename;

@interface SharingOption : NSObject {
    
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;

+ (SharingOption *)sharingOptionWithTitle:(NSString *)title andImage:(UIImage *)image;
+ (SharingOption *)sharingOptionWithTitle:(NSString *)title andImageIdentifier:(NSString *)imageIdentifier;

- (id)initWithTitle:(NSString *)title andImage:(UIImage *)image;

@end

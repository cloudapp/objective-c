//
//  ExternalAuthViewController.h
//  Cloud
//
//  Created by Héctor Cuevas Morfín on 8/30/18.
//  Copyright © 2018 CloudApp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExternalAuthViewControllerDelegate <NSObject>

@optional
- (void)didLoginWithToken:(NSString*)token;
- (void)loginCanceled;

@end

@interface ExternalAuthViewController : UIViewController
@property (weak) id <ExternalAuthViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

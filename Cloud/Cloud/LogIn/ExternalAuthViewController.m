//
//  ExternalAuthViewController.m
//  Cloud
//
//  Created by Héctor Cuevas Morfín on 8/30/18.
//  Copyright © 2018 CloudApp. All rights reserved.
//

#import "ExternalAuthViewController.h"
@import WebKit;


@interface ExternalAuthViewController () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ExternalAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_webView];
    
    UINavigationBar *nav = [self addNavigationBar];
    [NSLayoutConstraint activateConstraints:@[
                                              [_webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [_webView.topAnchor constraintEqualToAnchor:nav.bottomAnchor],
                                              [_webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [_webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              ]];
    
    
    NSURL *loadURL = [NSURL URLWithString:@"https://api.getcloudapp.com/auth/google_api_login"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:loadURL];
    _webView.customUserAgent = @"CloudAppSDK version 1.1";
    [_webView setUIDelegate:self];
    [_webView setNavigationDelegate:self];
    [_webView loadRequest:request];
}

- (UINavigationBar*)addNavigationBar {
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectZero];
    //[UINavigationBar appearance].barTintColor = [UIColor lightGrayColor];
    //[UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [myNav setTranslatesAutoresizingMaskIntoConstraints:NO];
    myNav.barTintColor = [UIColor whiteColor];
    [self.view addSubview:myNav];
    
    
    [NSLayoutConstraint activateConstraints:@[
                                              [myNav.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [myNav.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [myNav.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor]
                                              ]];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(closeViewController)];
    
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Login for CloudApp"];
    // navigItem.rightBarButtonItem = doneItem;
    navigItem.leftBarButtonItem = cancelItem;
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
    
    [UIBarButtonItem appearance].tintColor = [UIColor blueColor];
    
    return  myNav;
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([navigationResponse.response.MIMEType isEqualToString:@"application/vnd.collection+json"]) {
        [_webView setHidden:YES];
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('pre')[0].innerHTML" completionHandler:^(id _Nullable finished, NSError * _Nullable error) {
        if (!error) {
        NSData *data = [finished dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *authCredentialsJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
        NSLog(@"%@", authCredentialsJSON);
            
            NSArray *items = [[[[authCredentialsJSON objectForKey:@"collection"] objectForKey:@"items"] objectAtIndex:0]objectForKey:@"data"];
            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj objectForKey:@"name"] isEqualToString:@"token"]) {
                    NSLog(@"Toke:== %@", [obj objectForKey:@"value"]);
                    NSString *token = [obj objectForKey:@"value"];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginWithToken:)]) {
                        [self.delegate didLoginWithToken:token];
                    }
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }];
    
}


@end

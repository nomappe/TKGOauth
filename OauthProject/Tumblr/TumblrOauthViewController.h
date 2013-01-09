//
//  TumblrOauthViewController.h
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAMutableURLRequest.h"

@protocol TumblrOauthViewControllerDelegate;

@interface TumblrOauthViewController : UIViewController <UIWebViewDelegate>

//Delegate
@property (nonatomic, assign) id <TumblrOauthViewControllerDelegate> tumblrOauthViewControllerDelegate;
//各パラメータ
@property (strong, nonatomic) NSString *callbackURI;
@property (strong, nonatomic) NSString *consumerKey;
@property (strong, nonatomic) NSString *consumerSecret;
//認証画面
@property (weak, nonatomic) IBOutlet UIWebView *oauthWebView;

@end

@protocol TumblrOauthViewControllerDelegate <NSObject>

@optional
- (void)tumblrOauthFailed:(NSString *)error;
- (void)tumblrOauthSucceed:(NSString *)accessToken withSecretKey:(NSString *)secretKey;

@end

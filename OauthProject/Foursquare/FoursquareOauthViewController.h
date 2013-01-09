//
//  FoursquareOauthViewController.h
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FoursquareOauthViewControllerDelegate;

@interface FoursquareOauthViewController : UIViewController <UIWebViewDelegate>

//Delegate
@property (nonatomic, assign) id <FoursquareOauthViewControllerDelegate> foursquareOauthViewControllerDelegate;
//各パラメータ
@property (strong, nonatomic) NSString *callbackURI;
@property (strong, nonatomic) NSString *crientID;
//認証画面
@property (weak, nonatomic) IBOutlet UIWebView *oauthWebView;

@end

@protocol FoursquareOauthViewControllerDelegate <NSObject>

@optional
- (void)foursquareOauthFailed:(NSString *)error;
- (void)foursquareOauthSucceed:(NSString *)accessToken;

@end
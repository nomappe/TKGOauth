//
//  FoursquareOauthViewController.m
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import "FoursquareOauthViewController.h"

@interface FoursquareOauthViewController ()

@end

@implementation FoursquareOauthViewController

#pragma mark - Init
- (void)initView
{
    //ナビゲーションバーの設定
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    //タイトル
    self.navigationItem.title = @"Foursquare";
    
    //各キーのチェック
    if ([self.callbackURI isEqualToString:@""] || [self.crientID isEqualToString:@""]) {
        if ([self.foursquareOauthViewControllerDelegate respondsToSelector:@selector(foursquareOauthFailed:)]) {
            [self.foursquareOauthViewControllerDelegate foursquareOauthFailed:@"必須キーが設定されていません。"];
            return;
        }
    }
    
    //WebView初期化
    [self.oauthWebView setScalesPageToFit:YES];
    [self.oauthWebView setDelegate:self];
    //認証開始
    [self startLogin];
}

#pragma mark - View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初期化
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setOauthWebView:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions
- (void)cancel:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.oauthWebView setDelegate:nil];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Oauth Method
- (void)startLogin
{
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", self.crientID, self.callbackURI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.oauthWebView loadRequest:request];
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *URLString = [[self.oauthWebView.request URL] absoluteString];
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        if ([self.foursquareOauthViewControllerDelegate respondsToSelector:@selector(foursquareOauthSucceed:)]) {
            [self.foursquareOauthViewControllerDelegate foursquareOauthSucceed:accessToken];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([self.foursquareOauthViewControllerDelegate respondsToSelector:@selector(foursquareOauthFailed:)]) {
        [self.foursquareOauthViewControllerDelegate foursquareOauthFailed:@"通信エラー"];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end

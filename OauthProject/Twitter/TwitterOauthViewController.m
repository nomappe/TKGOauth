//
//  TwitterOauthViewController.m
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import "TwitterOauthViewController.h"

@interface TwitterOauthViewController ()

@end

@implementation TwitterOauthViewController
{
    OAConsumer *consumer;
    OAToken *accessToken;
}

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
    self.navigationItem.title = @"Twitter";
    
    //各キーのチェック
    if ([self.callbackURI isEqualToString:@""] || [self.consumerKey isEqualToString:@""] || [self.consumerSecret isEqualToString:@""]) {
        if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthFailed:)]) {
            [self.twitterOauthViewControllerDelegate twitterOauthFailed:@"必須キーが設定されていません。"];
            return;
        }
    }
    
    //WebView初期化
    [self.oauthWebView setScalesPageToFit:YES];
    [self.oauthWebView setDelegate:self];
    //Oauthライブラリ初期化
    consumer = [[OAConsumer alloc] initWithKey:self.consumerKey secret:self.consumerSecret];
    //トークン要求
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
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil
                                                          signatureProvider:nil];
	[request setHTTPMethod:@"POST"];
	
	//インジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishGetRequestToken:)
				  didFailSelector:@selector(requestTokenTicket:didFailTwitterSubmitterWithError:)];
}

#pragma mark - OADataFetcher Delegate
- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishGetRequestToken:(NSData *)data {
	//インジケータ非表示
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    if (ticket.didSucceed){
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
        NSString *address = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@&force_login=true", accessToken.key];
        NSURL *url = [NSURL URLWithString:address];
		
		//ブラウザ表示
		self.oauthWebView.hidden = NO;
		[self.oauthWebView loadRequest:[NSURLRequest requestWithURL:url]];
		
    } else {
        //エラー処理
        if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthFailed:)]) {
            NSString *error = [NSString stringWithFormat:@"トークン要求でエラーが発生しました。%@",[ticket.data description]];
            [self.twitterOauthViewControllerDelegate twitterOauthFailed:error];
            return;
        }
	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailTwitterSubmitterWithError:(NSError *)error {
	//インジケータ非表示
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthFailed:)]) {
        [self.twitterOauthViewControllerDelegate twitterOauthFailed:[error description]];
        return;
    }
}

#pragma mark - Oauth Succeed
- (void) backFromBrowser:(NSURL *)responseURL {
	
	//クエリからアクセストークンを取得
	accessToken = [accessToken initWithHTTPResponseBody:[responseURL query]];
    
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc]  initWithURL:url
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:nil];
	[request setHTTPMethod:@"POST"];
	
	//インジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishfetchAccessToken:)
				  didFailSelector:@selector(requestTokenTicket:didFailTwitterSubmitterWithError:)];
}

- (void) responseData:(NSURL *)responseData didFailTwitterSubmittingWebView:(NSError *)error {
	if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthFailed:)]) {
        [self.twitterOauthViewControllerDelegate twitterOauthFailed:[error description]];
        return;
    }
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishfetchAccessToken:(NSData *)data {
	//	ネットワークアクセスインジケータ非表示
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (ticket.didSucceed){
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        accessToken = [accessToken initWithHTTPResponseBody:responseBody];
        
        if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthSucceed:withSecretKey:withScreenName:)]) {
            [self.twitterOauthViewControllerDelegate twitterOauthSucceed:accessToken.key withSecretKey:accessToken.secret withScreenName:accessToken.screen_name];
        }
        
    } else {
		if ([self.twitterOauthViewControllerDelegate respondsToSelector:@selector(twitterOauthFailed:)]) {
            NSString *error = [NSString stringWithFormat:@"アクセストークン要求でエラーが発生しました。%@",[ticket.data description]];
            [self.twitterOauthViewControllerDelegate twitterOauthFailed:error];
            return;
        }
	}
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	//インジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	//インジケータ非表示
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSURL* url = [NSURL URLWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.URL"]];
	
	//認証了の場合にコールバックされるURL　Twitterのアプリ登録時に設定したURLです。
	NSURL *kanryoURL = [NSURL URLWithString:self.callbackURI];
	
	//ロードされたURLと、コールバックされるURLのhostが同じなら、承認されたと見なす
	if ([[url host] isEqualToString:[kanryoURL host]]) {
		[self performSelector:@selector(backFromBrowser:) withObject:url];
		//webViewを隠す
		self.oauthWebView.hidden = YES;
	}
}

@end

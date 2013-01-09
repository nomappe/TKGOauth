//
//  ViewController.m
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTokenLabel:nil];
    [self setSecretLabel:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions
- (IBAction)twitter:(id)sender {
    //Twitter認証
    TwitterOauthViewController *twitter = [[TwitterOauthViewController alloc] initWithNibName:@"TwitterOauthViewController" bundle:nil];
    [twitter setCallbackURI:@""];    //コールバックURL
    [twitter setConsumerKey:@""];    //ConsumerKey
    [twitter setConsumerSecret:@""]; //SecretKey
    [twitter setTwitterOauthViewControllerDelegate:self];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:twitter];
    [self presentModalViewController:navCon animated:YES];
}

- (IBAction)tumblr:(id)sender {
    //Tumblr認証
    TumblrOauthViewController *tumblr = [[TumblrOauthViewController alloc] initWithNibName:@"TumblrOauthViewController" bundle:nil];
    [tumblr setCallbackURI:@""];    //コールバックURL
    [tumblr setConsumerKey:@""];    //ConsumerKey
    [tumblr setConsumerSecret:@""]; //SecretKey
    [tumblr setTumblrOauthViewControllerDelegate:self];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:tumblr];
    [self presentModalViewController:navCon animated:YES];
}

- (IBAction)foursquare:(id)sender {
    //foursquare認証
    FoursquareOauthViewController *foursquare = [[FoursquareOauthViewController alloc] initWithNibName:@"FoursquareOauthViewController" bundle:nil];
    [foursquare setCallbackURI:@""]; //コールバックURL
    [foursquare setCrientID:@""];    //CrientID
    [foursquare setFoursquareOauthViewControllerDelegate:self];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:foursquare];
    [self presentModalViewController:navCon animated:YES];
}

#pragma mark - TwitterOauth Delegate
- (void)twitterOauthSucceed:(NSString *)accessToken withSecretKey:(NSString *)secretKey withScreenName:(NSString *)name
{
    [self.tokenLabel  setText:accessToken];
    [self.secretLabel setText:secretKey];
    [self.nameLabel   setText:name];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)twitterOauthFailed:(NSString *)error
{
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"%@",error);
}

#pragma mark - TumblrOauth Delegate
- (void)tumblrOauthSucceed:(NSString *)accessToken withSecretKey:(NSString *)secretKey
{
    [self.tokenLabel  setText:accessToken];
    [self.secretLabel setText:secretKey];
    [self.nameLabel   setText:@""];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tumblrOauthFailed:(NSString *)error
{
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"%@",error);
}

#pragma mark - FoursquareOauth Delegate
- (void)foursquareOauthSucceed:(NSString *)accessToken
{
    [self.tokenLabel  setText:accessToken];
    [self.secretLabel setText:@""];
    [self.nameLabel   setText:@""];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)foursquareOauthFailed:(NSString *)error
{
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"%@",error);
}

@end

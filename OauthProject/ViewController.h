//
//  ViewController.h
//  OauthProject
//
//  Created by 古林 俊祐 on 2013/01/09.
//  Copyright (c) 2013年 古林 俊祐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterOauthViewController.h"
#import "TumblrOauthViewController.h"
#import "FoursquareOauthViewController.h"

@interface ViewController : UIViewController <TwitterOauthViewControllerDelegate, TumblrOauthViewControllerDelegate, FoursquareOauthViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *secretLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)twitter:(id)sender;
- (IBAction)tumblr:(id)sender;
- (IBAction)foursquare:(id)sender;

@end

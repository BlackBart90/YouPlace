//
//  LoginViewController.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeButton.h"

@class LoginViewController;

@protocol LoginDelegate <NSObject>

-(void)userDidLoggedIn:(LoginViewController *)loginController;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,weak)IBOutlet AwesomeButton *fbButton;
@property (nonatomic,weak) id <LoginDelegate> delegate;

-(IBAction)loginFacebook:(id)sender;

@end

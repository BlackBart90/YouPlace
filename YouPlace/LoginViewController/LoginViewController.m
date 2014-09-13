//
//  LoginViewController.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountParse.h"
#import "ColorConverter.h"

@interface LoginViewController ()<MyParseAccountProtocol>

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fbButton.ownTitle = @"Facebook";
    self.fbButton.ownCode = @"\uf082";
    self.fbButton.fontCodeColor = [ColorConverter colorWithHexString:@"3B5998"];
    self.fbButton.ownCodeSize = 30;
    
    
    self.fbButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fbButton.layer.shadowOpacity = 0.1;
    self.fbButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.fbButton.layer.shadowRadius = 1;

    // Do any additional setup after loading the view from its nib.
}
-(void)loginFacebook:(id)sender
{
    [AccountParse sharedClass].delegate = self;
    [[AccountParse sharedClass] login];
}
-(void)userDidLoggedIn
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate userDidLoggedIn:self];
    
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

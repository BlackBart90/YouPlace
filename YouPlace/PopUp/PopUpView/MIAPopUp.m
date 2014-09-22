//
//  MIAPopUp.m
//  FwkTest
//
//  Created by Jacopo on 04/08/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIAPopUp.h"
#import "MIAPopUpFactory.h"
#import "MIAAnimationFactory.h"
#import "MIABaseAnimationView.h"

@interface MIAPopUp()
{
    UIView *overlayView;
}

@property (nonatomic) MIABasePopUp *selectedView;
@property (nonatomic,strong) UIViewController *parentController;
@property (nonatomic,strong) NSString *defaultAnimation;
@property (nonatomic,strong) MIABaseAnimationView *openingAnimation;
@property (nonatomic,strong) MIABaseAnimationView *endingAnimation;
@property (nonatomic,strong) NSMutableDictionary *dataArgs;

@end

@implementation MIAPopUp
-(NSMutableDictionary *)dataArgs
{
    if (!_dataArgs) {
        _dataArgs = [[NSMutableDictionary alloc]init];
    }
    return _dataArgs;
}

- (instancetype)initInController:(UIViewController *)controller type:(NSString *)type message:(NSString *)message andTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        if (message) {
            [self.dataArgs setObject:message forKey:@"message"];

        }
        if (title)
        {
            [self.dataArgs setObject:title forKey:@"title"];

        }
        self.parentController = controller;
        [self loadPopUpViewFromName:type];
    }
    return self;
}
-(void)loadPopUpViewFromName:(NSString *)name
{
    self.selectedView =  [MIAPopUpFactory popUpFromString:name layoutArgs:nil dataArgs:self.dataArgs];
    self.selectedView.renderer = self;
    // setting frame
    int width = self.parentController.view.bounds.size.width;
    int height = self.parentController.view.bounds.size.height;
    
    self.selectedView.frame = CGRectMake((width-self.selectedView.bounds.size.width)/2, (height-self.selectedView.bounds.size.height)/2-40, self.selectedView.bounds.size.width, self.selectedView.bounds.size.height);
    [self.parentController.view addSubview:self.selectedView];
    
}
-(void)loadOption
{
    MIAAnimationOptions *customOpenOption = [[MIAAnimationOptions alloc]init];
    customOpenOption.startTimeInterval = 1;
    MIAAnimationOptions *customCloseOption = [[MIAAnimationOptions alloc]init];
    customCloseOption.endTimeInterval = 1;
    Class animationOpenClass;
    Class animationCloseClass;
    
    if (self.openingAnimationName != nil) {
        animationOpenClass = [MIAAnimationFactory animationFromKey:self.openingAnimationName];
    }else
    {
        animationOpenClass = [MIAAnimationFactory animationFromKey:@"translate"];

    }
    if (self.endingAnimationName != nil) {
        animationCloseClass = [MIAAnimationFactory animationFromKey:self.endingAnimationName];
    }else
    {
        animationCloseClass = [MIAAnimationFactory animationFromKey:@"translate"];

    }
    self.openingAnimation = [[animationOpenClass alloc]initWithAnimatedView:self.selectedView inController:self.parentController options:customOpenOption];
    self.endingAnimation = [[animationCloseClass alloc]initWithAnimatedView:self.selectedView inController:self.parentController options:customCloseOption];
}
-(void)close
{
    [self.endingAnimation endingAnimationWithFinalBlock:^{}];
    [UIView animateWithDuration:0.5 animations:^{
        overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
    }];
}

-(void)addOverlayLayer
{
    overlayView = [UIView new];
    overlayView.frame = self.parentController.view.bounds;
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self.parentController.view addSubview:overlayView];
    [UIView animateWithDuration:0.5 animations:^{
        overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

-(void)show
{
    [self loadOption];
    [self addOverlayLayer];
    [self.parentController.view bringSubviewToFront:self.selectedView];
    
    self.selectedView.delegate = self.delegate;
    
    [self.openingAnimation openingAnimationWithFinalBlock:^{}];
}
@end

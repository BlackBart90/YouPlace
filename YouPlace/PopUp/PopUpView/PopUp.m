//
//  PopUp.m
//  FwkTest
//
//  Created by Jacopo on 04/08/14.
//  
//

#import "PopUp.h"
#import "PopUpFactory.h"
#import "AnimationFactory.h"
#import "BaseAnimationView.h"

@interface PopUp()
{
    UIView *overlayView;
}

@property (nonatomic) BasePopUp *selectedView;
@property (nonatomic,strong) UIViewController *parentController;
@property (nonatomic,strong) NSString *defaultAnimation;
@property (nonatomic,strong) BaseAnimationView *openingAnimation;
@property (nonatomic,strong) BaseAnimationView *endingAnimation;
@property (nonatomic,strong) NSMutableDictionary *dataArgs;

@end

@implementation PopUp
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
    self.selectedView =  [PopUpFactory popUpFromString:name layoutArgs:nil dataArgs:self.dataArgs];
    self.selectedView.renderer = self;
    // setting frame
    int width = self.parentController.view.bounds.size.width;
    int height = self.parentController.view.bounds.size.height;
    
    self.selectedView.frame = CGRectMake((width-self.selectedView.bounds.size.width)/2, (height-self.selectedView.bounds.size.height)/2-40, self.selectedView.bounds.size.width, self.selectedView.bounds.size.height);
    [self.parentController.view addSubview:self.selectedView];
    
}
-(void)loadOption
{
    AnimationOptions *customOpenOption = [[AnimationOptions alloc]init];
    customOpenOption.startTimeInterval = 1;
    AnimationOptions *customCloseOption = [[AnimationOptions alloc]init];
    customCloseOption.endTimeInterval = 0.5;
    Class animationOpenClass;
    Class animationCloseClass;
    
    if (self.openingAnimationName != nil) {
        animationOpenClass = [AnimationFactory animationFromKey:self.openingAnimationName];
    }else
    {
        animationOpenClass = [AnimationFactory animationFromKey:@"translate"];

    }
    if (self.endingAnimationName != nil) {
        animationCloseClass = [AnimationFactory animationFromKey:self.endingAnimationName];
    }else
    {
        animationCloseClass = [AnimationFactory animationFromKey:@"translate"];

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
    
    [self.openingAnimation openingAnimationWithFinalBlock:^{
     
    }];
}
@end

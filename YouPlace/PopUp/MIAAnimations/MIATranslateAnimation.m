//
//  MIATranslateAnimation.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIATranslateAnimation.h"

@implementation MIATranslateAnimation
-(instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(MIAAnimationOptions *)options
{
    self = [super initWithAnimatedView:animatedView inController:controller options:options];
    if (self) {
        
    }
    return self;
}
-(void)openingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    
    int translation = -self.parentController.view.bounds.size.width;
    if ([self.options isKindOfClass:[MIATranslateAnimationOptions class]]) {
        MIATranslateAnimationOptions *translatingOption = (MIATranslateAnimationOptions *)self.options;

        if (translatingOption.side == sideRight) {
            translation = -translation;
        }
    }
    
    self.animatedView.transform = CGAffineTransformMakeTranslation(translation, 0);
    
    [UIView animateWithDuration:self.options.startTimeInterval animations:^{

        self.animatedView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        finalBlock();
    }];
}
-(void)endingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    int translation = self.parentController.view.bounds.size.width;
    [UIView animateWithDuration:self.options.startTimeInterval animations:^{
        self.animatedView.transform = CGAffineTransformMakeTranslation(translation, 0);
    } completion:^(BOOL finished) {
        finalBlock();
    }];
}
@end

@implementation MIATranslateAnimationOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.side = sideLeft;
    }
    return self;
}

@end

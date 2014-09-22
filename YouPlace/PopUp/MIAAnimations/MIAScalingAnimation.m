//
//  MIAScalingAnimation.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIAScalingAnimation.h"

@implementation MIAScalingAnimation
-(instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(MIAAnimationOptions *)options
{
    self = [super initWithAnimatedView:animatedView inController:controller options:options];
    if (self) {
    }
    return self;
}
-(void)openingAnimationWithFinalBlock:(void(^)(void))finalBlock
{
    self.animatedView.transform = CGAffineTransformMakeScale(.01, .01);
    self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

    
    float firstInterval = self.options.startTimeInterval/3;
    float secondInterval = firstInterval;
    float thirdInterval = firstInterval;
    
    [UIView animateWithDuration:firstInterval animations:^{
        self.animatedView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:secondInterval animations:^{
            self.animatedView.transform = CGAffineTransformMakeScale(.9, .9);

        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:thirdInterval animations:^{
                self.animatedView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                finalBlock();
            }];
        }];
    }];
}
-(void)endingAnimationWithFinalBlock:(void (^)(void))finalBlock
{

    [UIView animateWithDuration:self.options.endTimeInterval animations:^{
        self.animatedView.transform = CGAffineTransformMakeScale(.01, .01);
        self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        finalBlock();
    }];
}
@end

//
//  FadeAnimation.m
//  FwkTest
//
//  Created by Jacopo on 31/07/14.
//  
//

#import "FadeAnimation.h"

@implementation FadeAnimation
-(instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(AnimationOptions *)options
{
    self = [super initWithAnimatedView:animatedView inController:controller options:options];
    if (self) {
    }
    return self;
}
-(void)openingAnimationWithFinalBlock:(void(^)(void))finalBlock
{
    self.animatedView.alpha = 0;
    self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    
    float firstInterval = self.options.startTimeInterval;

    [UIView animateWithDuration:firstInterval animations:^{
        self.animatedView.alpha = 1;
        self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)endingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    
    float firstInterval = self.options.endTimeInterval;
    
    [UIView animateWithDuration:firstInterval animations:^{
        self.animatedView.alpha = 0;
        self.parentController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        
        finalBlock();
    }];
}
@end

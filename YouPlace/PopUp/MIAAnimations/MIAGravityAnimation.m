//
//  MIAGravityAnimation.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIAGravityAnimation.h"

@interface MIAGravityAnimation()
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation MIAGravityAnimation
-(instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(MIAAnimationOptions *)options
{
    self = [super initWithAnimatedView:animatedView inController:controller options:options];
    if (self) {
            _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.parentController.view];
    }
    return self;
}
-(void)openingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.animatedView.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), - CGRectGetMaxY(self.animatedView.bounds)+100);

    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.animatedView snapToPoint:keyWindow.center];
    snapBehaviour.damping = 0.7;
    [_animator addBehavior:snapBehaviour];
}
-(void)endingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.animatedView]];
    //[gravityBehavior setAngle:DEGREES_TO_RADIANS(270) magnitude:2];
    gravityBehavior.magnitude = 3;
    
    [_animator addBehavior:gravityBehavior];

    finalBlock();
}

@end

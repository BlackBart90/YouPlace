//
//  TranslateAnimation.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  
//

#import "TranslateAnimation.h"

@implementation TranslateAnimation
-(instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(AnimationOptions *)options
{
    self = [super initWithAnimatedView:animatedView inController:controller options:options];
    if (self) {
        
    }
    return self;
}
-(void)openingAnimationWithFinalBlock:(void (^)(void))finalBlock
{
    
    int translation = -self.parentController.view.bounds.size.width;
    if ([self.options isKindOfClass:[TranslateAnimationOptions class]]) {
        TranslateAnimationOptions *translatingOption = (TranslateAnimationOptions *)self.options;

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

@implementation TranslateAnimationOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.side = sideLeft;
    }
    return self;
}

@end

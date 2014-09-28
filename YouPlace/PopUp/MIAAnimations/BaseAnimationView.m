//
//  BaseAnimationView.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  
//

#import "BaseAnimationView.h"
@interface BaseAnimationView()

@end
@implementation BaseAnimationView


- (instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(AnimationOptions *)options
{
    self = [super init];
    if (self) {
        
        self.options = options;
        self.animatedView = animatedView;
        self.parentController = controller;
    }
    return self;
}

-(void)openingAnimationWithFinalBlock:(void (^)(void))finalBlock{NSAssert(false, @"must implement ""openingAnimation"" in custom animation");}
-(void)endingAnimationWithFinalBlock:(void (^)(void))finalBlock{NSAssert(false, @"must implement ""endingAnimation"" in custom animation");}

@end

@implementation AnimationOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endTimeInterval = 1;
        self.startTimeInterval = 1;
    }
    return self;
}

@end
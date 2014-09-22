//
//  MIABaseAnimationView.m
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIABaseAnimationView.h"
@interface MIABaseAnimationView()

@end
@implementation MIABaseAnimationView


- (instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(MIAAnimationOptions *)options
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

@implementation MIAAnimationOptions

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
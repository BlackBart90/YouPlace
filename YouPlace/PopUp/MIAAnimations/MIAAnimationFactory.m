//
//  MIAAnimationFactory.m
//  FwkTest
//
//  Created by Jacopo on 01/08/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIAAnimationFactory.h"
#import "MIAGravityAnimation.h"
#import "MIAScalingAnimation.h"
#import "MIAFadeAnimation.h"
#import "MIATranslateAnimation.h"

static NSDictionary * animationFactoryClassList;

@implementation MIAAnimationFactory
+(void)load
{
    animationFactoryClassList = @{@"translate":[MIATranslateAnimation class],
                                  @"gravity":[MIAGravityAnimation class],
                                  @"fade":[MIAFadeAnimation class],
                                  @"scale":[MIAScalingAnimation class]};
}
+(Class)animationFromKey:(NSString *)key
{
    Class class = [animationFactoryClassList objectForKey:key];
    return class;
}
@end

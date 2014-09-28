//
//  AnimationFactory.m
//  FwkTest
//
//  Created by Jacopo on 01/08/14.
//  
//

#import "AnimationFactory.h"
#import "GravityAnimation.h"
#import "ScalingAnimation.h"
#import "FadeAnimation.h"
#import "TranslateAnimation.h"

static NSDictionary * animationFactoryClassList;

@implementation AnimationFactory
+(void)load
{
    animationFactoryClassList = @{@"translate":[TranslateAnimation class],
                                  @"gravity":[GravityAnimation class],
                                  @"fade":[FadeAnimation class],
                                  @"scale":[ScalingAnimation class]};
}
+(Class)animationFromKey:(NSString *)key
{
    Class class = [animationFactoryClassList objectForKey:key];
    return class;
}
@end

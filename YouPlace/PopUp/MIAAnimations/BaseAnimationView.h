//
//  BaseAnimationView.h
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  
//

#import <Foundation/Foundation.h>

@class BaseAnimationView;


@interface AnimationOptions : NSObject

@property (nonatomic,assign) NSTimeInterval startTimeInterval;
@property (nonatomic,assign) NSTimeInterval endTimeInterval;

@end


@interface BaseAnimationView : NSObject

@property (nonatomic,strong) UIView *animatedView;
@property (nonatomic,strong) UIViewController *parentController;
@property (nonatomic,strong) AnimationOptions *options;

- (instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(AnimationOptions *)options;

- (void)openingAnimationWithFinalBlock:(void(^)(void))finalBlock;
- (void)endingAnimationWithFinalBlock:(void(^)(void))finalBlock;;

@end

//
//  MIABaseAnimationView.h
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIABaseAnimationView;


@interface MIAAnimationOptions : NSObject

@property (nonatomic,assign) NSTimeInterval startTimeInterval;
@property (nonatomic,assign) NSTimeInterval endTimeInterval;

@end


@interface MIABaseAnimationView : NSObject

@property (nonatomic,strong) UIView *animatedView;
@property (nonatomic,strong) UIViewController *parentController;
@property (nonatomic,strong) MIAAnimationOptions *options;

- (instancetype)initWithAnimatedView:(UIView *)animatedView inController:(UIViewController *)controller options:(MIAAnimationOptions *)options;

- (void)openingAnimationWithFinalBlock:(void(^)(void))finalBlock;
- (void)endingAnimationWithFinalBlock:(void(^)(void))finalBlock;;

@end

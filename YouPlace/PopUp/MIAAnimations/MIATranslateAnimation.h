//
//  MIATranslateAnimation.h
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIABaseAnimationView.h"

enum {
    sideLeft = 0,
    sideRight = 1,
};
typedef NSUInteger translateAnimationSide;

@interface MIATranslateAnimationOptions : MIAAnimationOptions

@property (nonatomic,assign) translateAnimationSide side;

@end

@interface MIATranslateAnimation : MIABaseAnimationView

@end

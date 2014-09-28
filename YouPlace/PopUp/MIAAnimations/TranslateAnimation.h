//
//  TranslateAnimation.h
//  FwkTest
//
//  Created by Jacopo on 28/07/14.
// 
//

#import "BaseAnimationView.h"

enum {
    sideLeft = 0,
    sideRight = 1,
};
typedef NSUInteger translateAnimationSide;

@interface TranslateAnimationOptions : AnimationOptions

@property (nonatomic,assign) translateAnimationSide side;

@end

@interface TranslateAnimation : BaseAnimationView

@end

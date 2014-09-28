//
//  AnimationFactory.h
//  FwkTest
//
//  Created by Jacopo on 01/08/14.
//  
//

#import <Foundation/Foundation.h>
#import "BaseAnimationView.h"

@interface AnimationFactory : NSObject


+(Class)animationFromKey:(NSString *)key;
@end

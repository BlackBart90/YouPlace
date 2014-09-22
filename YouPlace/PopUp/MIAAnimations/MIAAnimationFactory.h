//
//  MIAAnimationFactory.h
//  FwkTest
//
//  Created by Jacopo on 01/08/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIABaseAnimationView.h"

@interface MIAAnimationFactory : NSObject


+(Class)animationFromKey:(NSString *)key;
@end

//
//  MomentContainerFactory.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 24/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentContainer.h"

@interface MomentContainerFactory : NSObject
+ (void)registerMomentContainer:(MomentContainer *)momContainer withKey:(NSString *)key;
+ (MomentContainer *)getIstanceFromKey:(NSString *)key;

@end

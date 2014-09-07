//
//  MomentContainerFactory.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 24/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MomentContainerFactory.h"

static NSMutableDictionary *allMomentContainerDict;

@implementation MomentContainerFactory

+(void)load
{
    allMomentContainerDict = [[NSMutableDictionary alloc]init];
}

+(void)registerMomentContainer:(MomentContainer *)momContainer withKey:(NSString *)key
{
    [allMomentContainerDict setObject:momContainer forKey:key];
    
}

+ (MomentContainer *)getIstanceFromKey:(NSString *)key
{
    return [allMomentContainerDict objectForKey:key];
}
@end

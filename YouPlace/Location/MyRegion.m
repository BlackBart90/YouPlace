//
//  MyRegion.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MyRegion.h"

@implementation MyRegion
- (instancetype)initWithRegion:(CLRegion *)region andPlace:(Place *)place
{
    self = [super init];
    if (self) {
        self.region = region;
        self.place = place;
    }
    return self;
}

@end

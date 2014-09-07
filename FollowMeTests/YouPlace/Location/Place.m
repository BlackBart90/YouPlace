//
//  Place.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Place.h"

@implementation Place


-(BOOL)isEqualToPlace:(Place *)place
{
    if ([place.uniqueid isEqualToString:self.uniqueid]) {
        return YES;
    }else
        return NO;
}
-(Place *)validatePlace
{
    if (!self || !self.name || !self.uniqueid || !self.lat || !self.lng) {
        NSAssert(false, @"place is not complete");
        return nil;
    }else
        return self;
}
@end

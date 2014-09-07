//
//  MyRegion.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Place.h"

@interface MyRegion : NSObject
@property (nonatomic,strong) Place *place;
@property (nonatomic,strong) CLRegion *region;

- (instancetype)initWithRegion:(CLRegion *)region andPlace:(Place *)place;

@end

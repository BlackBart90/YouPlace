//
//  MomentsManager.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 13/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "Moment.h"

@interface MomentsManager : NSObject
- (instancetype)initWithMoments:(NSArray *)moments;
- (NSArray *)divideAllMomentsByPlaces;
- (NSArray *)divideAllMomentsByMomentContainer;

- (NSArray *)momentsContainersFromArray:(NSArray *)arrayOfArray andCurrentPlace:(Place *)place;
- (NSArray *)getArrayOfMomentsFromPlaceIdKey:(NSString *)key;
- (MomentContainer *)momentContainerFromMoments:(NSArray *)moments;

@end

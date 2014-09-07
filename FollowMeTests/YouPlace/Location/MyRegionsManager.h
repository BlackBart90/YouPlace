//
//  MyRegionsManager.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 19/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyRegion.h"
#import "Place.h"

@interface MyRegionsManager : NSObject
+(void)checkCoordinates:(CLLocationCoordinate2D)coordinates inRegions:(NSArray *)regions successBlock:(void(^)(Place *place))success failure:(void(^)(void))failure;

@end

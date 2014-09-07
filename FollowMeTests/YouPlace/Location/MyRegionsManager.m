//
//  MyRegionsManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 19/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MyRegionsManager.h"


@implementation MyRegionsManager
+(void)checkCoordinates:(CLLocationCoordinate2D)coordinates inRegions:(NSArray *)regions successBlock:(void(^)(Place *place))success failure:(void(^)(void))failure{
    BOOL check = false;
    for (MyRegion *m_region in regions) {
        
        CLCircularRegion *circularRegion = (CLCircularRegion *) m_region.region;
        if ([circularRegion containsCoordinate:coordinates]) {
      
            success(m_region.place);
            check = true;
            break;
        }
    }
    if (!check) {
        failure();
    }
}
@end

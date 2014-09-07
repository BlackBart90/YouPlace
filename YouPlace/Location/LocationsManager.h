//
//  LocationsManager.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 05/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface LocationsManager : NSObject
@property (nonatomic,strong) CLLocation *mainLocation;

-(void)startNewLocationObserver;
-(NSTimeInterval)getLocationtime;
-(float)getDistance;

-(void)loadLocation:(CLLocation*)location;

@end

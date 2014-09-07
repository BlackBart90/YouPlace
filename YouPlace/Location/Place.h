//
//  Place.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface Place : NSObject
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *uniqueid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int regionRadius;
-(BOOL)isEqualToPlace:(Place *)place;
-(Place *)validatePlace;


@end

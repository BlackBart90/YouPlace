//
//  MomentContainer.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface MomentContainer : NSObject

@property (nonatomic,assign) BOOL currentPlace;
@property (nonatomic,assign) int numberOfMoments;
@property (nonatomic,strong) NSString *placeName;
@property (nonatomic,strong) NSDictionary *generalInfo;
@property (nonatomic,strong) NSString *mainPlaceId;
@property (nonatomic,strong) NSString *momentIdTest;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *uniqueID;
@property (nonatomic,strong) NSString *name;
- (instancetype)initWithMoments:(NSArray *)moments;
- (BOOL)isEqualToMomentContainer:(MomentContainer *)momentContainer;

@end

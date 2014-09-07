//
//  MainViewController.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Place.h"
#import "PlaceScroller.h"


@interface MainViewController : UIViewController


@property (nonatomic,strong) PlaceScroller *placeScroll;

- (Place *)getCurrentPlace;
- (void)loadContainers;
- (void)loadRegionsWithFinalBlock:(void(^)(void))finalBlock;

@end

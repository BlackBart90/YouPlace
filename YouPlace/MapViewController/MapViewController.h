//
//  MapViewController.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 17/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import CoreLocation;

@interface MapViewController : UIViewController

@property (nonatomic,strong) NSArray *regions;
@property (nonatomic,assign) CLLocationCoordinate2D customCoordinates;
@property (nonatomic,weak) IBOutlet MKMapView *mainMap;
@end

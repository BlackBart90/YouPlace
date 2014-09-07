//
//  SinglePlaceView.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "MomentContainer.h"
#import "FileUploaderManager.h"
#import "Place.h"
#import "TappedView.h"

@import CoreLocation;
@class SinglePlaceView;

@protocol PlaceViewProtocol <NSObject>

-(void)didTapMapInView:(SinglePlaceView *)placeView;

@end

@interface SinglePlaceView : TappedView

@property (nonatomic,strong) NSString *placeId;

@property (nonatomic,strong) MomentContainer *ownContainer;

@property (nonatomic,assign) BOOL currentPlace;
@property (nonatomic,weak) IBOutlet UILabel *placeName;
@property (nonatomic,weak) IBOutlet UILabel *n_moments;

@property (nonatomic,weak) IBOutlet UILabel *sonoQui;
@property (nonatomic,weak) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet MKMapView *mapView;


@property (nonatomic,weak) IBOutlet UIButton *saveMomentButton;
@property (nonatomic,weak) IBOutlet UIButton *savePhotoInMomentButton;


@property (nonatomic,assign) CLLocationCoordinate2D coordinates;



// temporary
@property (nonatomic,weak) IBOutlet PFImageView *imageViewTest;
@property (nonatomic,weak) IBOutlet PFImageView *imageViewTest_2;
@property (nonatomic,weak) IBOutlet PFImageView *imageViewTest_3;


//


@property (nonatomic,weak) id <PlaceViewProtocol> delegate;
+ (SinglePlaceView *)loadSinglePlaceView;

-(IBAction)saveMoment:(id)sender;
-(IBAction)savePhoto:(id)sender;
-(IBAction)saveNote:(id)sender;

@end

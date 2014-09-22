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
#import "BrutalUIImageView.h"
#import "NewMomentButton.h"


@import CoreLocation;
@class SinglePlaceView;

@protocol PlaceViewProtocol <NSObject>

-(void)didTapMapInView:(SinglePlaceView *)placeView;

@end

@interface SinglePlaceView : TappedView

@property (nonatomic,strong) NSString *placeId;

@property (nonatomic,weak) MomentContainer *ownContainer;

@property (nonatomic,assign) BOOL currentPlace;
@property (nonatomic,weak) IBOutlet UIView *containerNameView;
@property (nonatomic,weak) IBOutlet UILabel *placeName;
@property (nonatomic,weak) IBOutlet UILabel *n_moments;

@property (nonatomic,weak) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet MKMapView *mapView;


@property (nonatomic,assign) CLLocationCoordinate2D coordinates;

@property (nonatomic,weak) IBOutlet UIView *containerPhotos;
@property (nonatomic,weak) IBOutlet UIView *containerNotes;
@property (nonatomic,weak) IBOutlet UIView *containerContacts;

@property (nonatomic,weak) IBOutlet NewMomentButton *addPhotosButton;
@property (nonatomic,weak) IBOutlet NewMomentButton *addNoteButton;

// temporary
@property (nonatomic,weak) IBOutlet BrutalUIImageView *imageViewTest_2;
@property (nonatomic,weak) IBOutlet BrutalUIImageView *imageViewTest_3;


@property (nonatomic,weak) id <PlaceViewProtocol> delegate;
+ (SinglePlaceView *)loadSinglePlaceView;
- (void)loadImages;

-(IBAction)savePhoto:(id)sender;
-(IBAction)saveNote:(id)sender;
-(IBAction)saveContact:(id)sender;

@end

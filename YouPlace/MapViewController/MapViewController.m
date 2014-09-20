//
//  MapViewController.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 17/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MapViewController.h"
#import "MyRegion.h"

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainMap.showsUserLocation = YES;
    self.mainMap.delegate = self;
    [self.mainMap setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    MKCoordinateRegion mapRegion;
    if (self.customCoordinates.latitude && self.customCoordinates.longitude ) {
        mapRegion.center = self.customCoordinates;
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = self.customCoordinates;
        [self.mainMap addAnnotation:annotationPoint];

    }
    mapRegion.span.latitudeDelta = 0.02;
    mapRegion.span.longitudeDelta = 0.02;
    
    [self.mainMap setRegion:mapRegion animated: NO];
    for (MyRegion *mRegion in self.regions) {
        CLLocationCoordinate2D coor;
        coor.latitude = [mRegion.place.lat doubleValue];
        coor.longitude = [mRegion.place.lng doubleValue];
        
        [self createRegionWithRadius:mRegion.place.regionRadius inCenter:coor andIndentifier:mRegion.place.name];
    }
//    _mainMap.showsUserLocation = YES;

    // Do any additional setup after loading the view from its nib.
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
}
/*
-(void)viewWillAppear:(BOOL)animated
{
    WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.mapView];
        
        CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        MKMapPoint mapPoint = MKMapPointForCoordinate(coord);
        for (id overlay in self.mapView.overlays)
        {
            
            if ([overlay isKindOfClass:[MKCircle class]])
            {
                MKCircle *polyView = (MKCircle*) overlay;
                MKCircleRenderer *circlerenderer = [[MKCircleRenderer alloc]initWithCircle:polyView];
                CGPoint polygonViewPoint = [circlerenderer pointForMapPoint:mapPoint];
                BOOL mapCoordinateIsInPolygon = CGPathContainsPoint(circlerenderer.path, NULL, polygonViewPoint, NO);
                if (mapCoordinateIsInPolygon) {
                    NSLog(@"hit!");
                    break;
                } else {
                    //                        NSLog(@"miss!");
                }
            }
        }
    };
    self.locMan = [[LocationsManager alloc]init];
    
    
}*/
-(void)createRegionWithRadius:(int)meters inCenter:(CLLocationCoordinate2D)location andIndentifier:(NSString *)identifier
{
    
    // Check the authorization status
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) &&
        ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined))
        return ;
    
//    CLLocationDegrees radius = meters;
//    if (radius > self.locationManager.maximumRegionMonitoringDistance) {
//        radius = self.locationManager.maximumRegionMonitoringDistance;
//    }
//    
    //overlay
    [self.mainMap addOverlay:[MKCircle circleWithCenterCoordinate:location radius:meters]];
 
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    MKCircleRenderer*renderCircle = [[MKCircleRenderer alloc]initWithCircle:(MKCircle *)overlay];
    renderCircle.fillColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    
    return renderCircle;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MainViewController.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MainViewController.h"
#import "AccountParse.h"
#import "LoginViewController.h"
#import "WildcardGestureRecognizer.h"
#import "LocalNotificationManager.h"
#import "LocationsManager.h"
#import "ParseData.h"
#import "Place.h"
#import "Utils.h"
#import "HistoryViewController.h"
#import "MomentsManager.h"
#import "MomentCell.h"
#import "MyRegion.h"
#import "MapViewController.h"
#import "FileUploaderManager.h"
#import "MyRegionsManager.h"
#import "DetailContainerViewController.h"
#import "DataManager.h"

@interface MainViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate,PlaceScrollerProtocol,UIImagePickerControllerDelegate,LoginDelegate>
{
     BOOL currentPlaceChanged;
    Place *tmpPlace;
    MomentsManager *m_manager ;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Place *currentPlace;
@property (strong, nonatomic) NSMutableArray *allRegions;
@property (strong, nonatomic) LocationsManager *locMan;
@property (assign, nonatomic) BOOL insideRegion;


//@property (nonatomic, copy) void (^currentPlaceUpdating)(Place *c_place, BOOL sendLocation);
@end

@implementation MainViewController
-(void)setCurrentPlace:(Place *)currentPlace{

    _currentPlace = currentPlace;
}
-(NSMutableArray *)allRegions
{
    if (!_allRegions) {
        _allRegions = [[NSMutableArray alloc]init];
    }
    return _allRegions;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    tmpPlace = [Place new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didenterInbackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    int height = 10;
    
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        height = self.view.bounds.size.height-44-20;
    }else
    {
        height = [[UIScreen mainScreen] bounds].size.height-44-20;
    }
    
    self.placeScroll = [[PlaceScroller alloc]initWithFrame:CGRectMake(0, 0, 320, height) andDataSource:nil];
    self.placeScroll.delegateScroller = self;
    [self.view addSubview:self.placeScroll];
}
-(void)didBecomeActive
{
    NSLog(@"You Place is active");
    
    if (![[AccountParse sharedClass] userLoggedIn]) {
        LoginViewController *loginController = [[LoginViewController alloc]init];
        loginController.delegate = self;
        [self presentViewController:loginController animated:YES completion:^{
        
            NSLog(@"present login");
        }];
    }else
    {
        [self startLocalization];
        [self loadRegionsWithFinalBlock:^{
            
            [self loadContainers];
        }];
    }
}
-(void)userDidLoggedIn:(LoginViewController *)loginController
{
    [self startLocalization];
    [self loadRegionsWithFinalBlock:^{
        
        [self loadContainers];
    }];
}
-(void)didenterInbackground
{
    NSLog(@"enter in background");
    [self.locationManager stopUpdatingLocation];

}
-(void)loadContainers
{
    __block PlaceScroller *ptPlaceScroller = self.placeScroll;
    
    
    [DataManager loadMoments:^(NSArray *moments) {
        
        m_manager = [[MomentsManager alloc]initWithMoments:moments];
        //NSArray *placesArray = [m_manager divideAllMomentsByPlaces];
        // NSArray *momentsContainer = [m_manager momentsContainersFromArray:placesArray andCurrentPlace:self.currentPlace];
        NSArray *array = [m_manager divideAllMomentsByMomentContainer];
        NSArray *momentsContainer = [m_manager momentsContainersFromArray:array andCurrentPlace:self.currentPlace];
        ptPlaceScroller.dataSource = [[NSMutableArray alloc]initWithArray:momentsContainer];
        [ptPlaceScroller reloadData];
        ptPlaceScroller.backgroundColor = [UIColor clearColor];
    } fromContainerName:nil];

}
-(void)removeAllRegions
{
    for (CLRegion *region in [[self.locationManager monitoredRegions] allObjects]) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    [self.allRegions removeAllObjects];
}
-(void)loadRegionsWithFinalBlock:(void(^)(void))finalBlock
{
    [self removeAllRegions];
    [DataManager loadPlaces:^(NSArray *places) {
        
        [self addRegionsInPlaces:places];
        finalBlock();
        
    } fromContainerName:nil];
}
-(void)addRegionsInPlaces:(NSArray *)places
{
    for (Place *place in places) {
        [self saveSingleRegionFromPlace:place];
    }
    
    [_locationManager startUpdatingLocation];
}
-(void)saveSingleRegionFromPlace:(Place *)place
{
    CLLocationCoordinate2D coor;
    coor.latitude = [place.lat doubleValue];
    coor.longitude = [place.lng doubleValue];
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coor radius:place.regionRadius identifier:place.uniqueid];
    [self.locationManager startMonitoringForRegion:(CLRegion *)region];
    
    if (region) {
        MyRegion *myReg = [[MyRegion alloc]initWithRegion:region andPlace:place];
        if (myReg) {
            [self.allRegions addObject:myReg];
        }
    }
}

- (MyRegion *)currentRegionFromCLRegion:(CLRegion *)region
{

    for (MyRegion *m_region in self.allRegions) {
//        NSLog(@"region : %@",m_region.place.name);

        if ([m_region.region isEqual:region]) {
        //    NSLog(@"region known : %@",m_region.place.name);
            return m_region;
            break;
        }else
        {
           // NSLog(@"region unknown");
        }
    }
    return nil;
}


-(void)viewWillAppear:(BOOL)animated
{    
    self.locMan = [[LocationsManager alloc]init];
    self.insideRegion = NO;
}
-(void)viewDidAppear:(BOOL)animated{
}

-(void)startLocalization{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSArray *arrMoment =  [m_manager getArrayOfMomentsFromPlaceIdKey:region.identifier];
    
    id object  = [m_manager momentContainerFromMoments:arrMoment];
    NSString *message = [NSString stringWithFormat:@"Sei arrivato a : %@",[object name]];

    if ([object isKindOfClass:[MomentContainer class]]) {
        [self.placeScroll scrollToItemFromMomentContainer:object scrollToFirst:NO];
    }
    
    NSLog(@"%@",message);
    
    MyRegion *reg = [self currentRegionFromCLRegion:region];
    self.currentPlace = reg.place;
    self.insideRegion = YES;
    [self loadContainers];
    [LocalNotificationManager localNotificationWithMessage:message];
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSArray *arrMoment =  [m_manager getArrayOfMomentsFromPlaceIdKey:region.identifier];
    id object  = [m_manager momentContainerFromMoments:arrMoment];
    NSString *message = [NSString stringWithFormat:@"Sei uscito da : %@",[object name]];

    NSLog(@"%@",message);
    [self.placeScroll scrollToItemFromMomentContainer:nil scrollToFirst:YES];

    self.currentPlace = nil;
    self.insideRegion = NO;
    [self loadContainers];
    [LocalNotificationManager localNotificationWithMessage:message];
}
- (Place *)getCurrentPlace
{
    if (self.currentPlace) {
        return self.currentPlace;
    }else
    {
        return [self newTmpPlaceWithSettings];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.insideRegion) {
    CLLocation *loc = [locations lastObject];
    double latdouble = loc.coordinate.latitude;
    double lngdouble = loc.coordinate.longitude;
    [MyRegionsManager checkCoordinates:CLLocationCoordinate2DMake(latdouble,lngdouble) inRegions:self.allRegions successBlock:^(Place *place) {
        self.currentPlace = place;
        self.insideRegion = YES;
        NSLog(@"luogo conosciuto");
                
    } failure:^{
        NSLog(@"luogo non conosciuto imposto un posto temporaneo");
        tmpPlace.lat = [NSString stringWithFormat:@"%f",latdouble];
        tmpPlace.lng = [NSString stringWithFormat:@"%f",lngdouble];
        self.currentPlace = nil;
        self.insideRegion = NO;
       // [self.placeScroll scrollToItemFromMomentContainer:nil scrollToFirst:YES];
    
    }];
        
    }
}

- (Place *)newTmpPlaceWithSettings
{
    tmpPlace.name = @"mio posto";
//    if (self.textName.text.length) {
//        tmpPlace.name = self.textName.text;
//    }
//    
    tmpPlace.regionRadius = (int) 50;
    
//    if (self.textMeters.text.length) {
//        tmpPlace.regionRadius = (int)[self.textMeters.text integerValue] ;
//    }
    tmpPlace.uniqueid = [Utils createUUID];
    return tmpPlace;
}
-(IBAction)removeLocation:(Place *)place
{

    [ParseData removePlaceFromServer:self.currentPlace success:^{
        [self loadRegionsWithFinalBlock:^{}];
        NSLog(@"%@ removed",self.currentPlace.name);
    } failure:^{
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - history 
-(void)history:(id)sender
{
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];

    HistoryViewController *history = [[HistoryViewController alloc]initWithCollectionViewLayout:layout];
    [history.collectionView registerClass:[MomentCell class] forCellWithReuseIdentifier:@"cell"];

    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark - Place Scroller delegate -
-(void)tapMapInView:(SinglePlaceView *)singlePlaceView
{
    
    MapViewController *mapController = [[MapViewController alloc]init];
    mapController.regions = self.allRegions;
    mapController.customCoordinates = singlePlaceView.coordinates;
    [self.navigationController pushViewController:mapController animated:YES];
}
-(void)tapView:(SinglePlaceView *)singlePlaceView
{
    NSLog(@"enter in detail!");
    MomentContainer *container = singlePlaceView.ownContainer;
    DetailContainerViewController *detailController = [[DetailContainerViewController alloc]init];
    detailController.detailedContainer = container;
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

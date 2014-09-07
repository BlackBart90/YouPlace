//
//  SinglePlaceView.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "SinglePlaceView.h"
#import "ParseData.h"
#import "MomentsManager.h"
#import "Utils.h"
#import "MainViewController.h"
#import "FileUploaderManager.h"

@interface SinglePlaceView () <MKMapViewDelegate,FileUploaderProtocol>

@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) MainViewController *ptMainController;

@end
@implementation SinglePlaceView
-(NSArray *)images
{
    if (!_images) {
        _images = @[self.imageViewTest,self.imageViewTest_2,self.imageViewTest_3];
    }
    return _images;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.mapView.showsUserLocation = YES;
        self.mapView.delegate = self;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        self.sonoQui.hidden = YES;

    }
    return self;
}
+ (SinglePlaceView *)loadSinglePlaceView
{
    SinglePlaceView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    return view;
}
-(void)tapMap
{
    [self.delegate didTapMapInView:self];
}
-(void)addingData
{
    if (self.ownContainer) {
    self.placeId = self.ownContainer.mainPlaceId;
    self.placeName.text = self.ownContainer.placeName;
    self.currentPlace = self.ownContainer.currentPlace;
    
    
//    
//    if (self.currentPlace) {
//        currentView = placeView;
//    }
//    
    
    self.coordinates = self.ownContainer.coordinate;
        self.n_moments.text = [NSString stringWithFormat:@"%i",self.ownContainer.numberOfMoments];
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;
    self.ptMainController = mainController;
    [self addingData];
    self.backgroundColor = [UIColor clearColor];
    self.containerView.frame = self.bounds;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 0;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 5;

    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 0.7;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.autoresizesSubviews = YES;
    
    
    if (self.currentPlace) {
        self.sonoQui.hidden = NO;
    }
    else self.sonoQui.hidden = YES;
    
 
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = self.coordinates;
    annotationPoint.title = @"Microsoft";
    
    
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    region.center = self.coordinates;
    span.latitudeDelta =  0.001;
    span.longitudeDelta =  0.001;
    region.span=span;
    
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView addAnnotation:annotationPoint];
    
    
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap)];
    [self.mapView addGestureRecognizer:tapMap];
    

    // loadimage
    
    [ParseData loadImageWithContainerName:self.ownContainer.name success:^(NSArray *arrayFile) {
        for (int i = 0; i < arrayFile.count; i++) {
            if (i<self.images.count) {
                if ([self.imageViewTest isKindOfClass:[PFImageView class]]) {
                    PFImageView *imageViewpt = (PFImageView *)[self.images objectAtIndex:i];
                    imageViewpt.contentMode = UIViewContentModeScaleAspectFit;
                    imageViewpt.file = (PFFile *)arrayFile[i];
                    [imageViewpt loadInBackground];
                }
            }
        }
    } error:^{
        
    }];
    
}
-(void)saveMoment:(id)sender
{
//    [self saveCurrentMomentInPlace:[self updatePlace] withFinal:^(Moment *moment) {
//        
//        NSLog(@"OK");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hai salvato un momento " message:@"attendi" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
//        [self.ptMainController loadContainers];
//    } errorBlock:^{
//        
//    }];
//    
}
-(void)savePhoto:(id)sender
{

    NSLog(@"moment container name : %@",self.ownContainer.placeName);
    [[FileUploaderManager sharedClass] newImageFromController:self.ptMainController andDelegate:self];

}
-(void)didUploadFileData:(NSData *)dataFile
{
    
    NSDictionary * dictData = @{@"name":kDefaultMomentName,
                                @"contName":self.ownContainer.name,
                                };
    
    [Moment saveCurrentMomentInPlace:[[self updatePlace] validatePlace] withData:dictData withFinal:^(Moment *moment) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hai salvato un momento " message:@"attendi" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.ptMainController loadRegionsWithFinalBlock:^{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Regioni ricaricate " message:@"attendi per l'upload della foto" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
        
        [ParseData uploadImageWithData:dataFile andMoment:moment success:^{
            NSLog(@"photo uploaded");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Foto caricata " message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.ptMainController loadContainers];
            
        } error:^{
            NSLog(@"error");
        }];
        
    } errorBlock:^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Qualcosa è andato storto" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}

-(void)saveNote:(id)sender
{
    
    NSDictionary * dictData = @{kMomentNameKEY:kDefaultMomentName,
                                kMomentContainerNameKEY:self.ownContainer.name,
                                kMomentNoteContentKEY:@"testo di prova",
                                };
    [Moment saveCurrentMomentInPlace:[[self updatePlace] validatePlace] withData:dictData withFinal:^(Moment *moment) {
        
        [self.ptMainController loadRegionsWithFinalBlock:^{
            [self.ptMainController loadContainers];

        }];

    } errorBlock:^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Qualcosa è andato storto" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }];

}

-(Place *)updatePlace
{
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;

    return [mainController getCurrentPlace];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

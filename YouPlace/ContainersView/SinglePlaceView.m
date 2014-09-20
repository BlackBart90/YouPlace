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
#import "DataManager.h"
#import "ColorConverter.h"

@interface SinglePlaceView () <MKMapViewDelegate,FileUploaderProtocol>

@property (nonatomic,retain) NSArray *images;
@property (nonatomic,strong) MainViewController *ptMainController;

@end
@implementation SinglePlaceView
-(NSArray *)images
{
    if (!_images) {
        _images = @[self.imageViewTest_2,self.imageViewTest_3];
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
    self.coordinates = self.ownContainer.coordinate;
        self.n_moments.text = [NSString stringWithFormat:@"%i",self.ownContainer.numberOfMoments];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self resettingFrames];
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
    self.containerView.layer.cornerRadius = 0;

    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 0.7;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.autoresizesSubviews = YES;
    
    self.placeName.backgroundColor = [UIColor clearColor];
    self.containerNameView.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerNameView.layer.shadowOpacity = 0.4;
    self.containerNameView.layer.shadowRadius = 1;
    self.containerNameView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //newMomentButton photos
    self.addPhotosButton.iconImageChar = @"\uf030";
    self.addPhotosButton.mainColor = [ColorConverter colorWithHexString:@"c13f21"];
    self.addPhotosButton.textColor = [ColorConverter colorWithHexString:@"ffffff"];
    
    
    
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
    span.latitudeDelta =  0.020;
    span.longitudeDelta =  0.020;
    region.span=span;
    self.mapView.alpha = 0.5;
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView addAnnotation:annotationPoint];
    
    
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap)];
    [self.mapView addGestureRecognizer:tapMap];
    

    //loadNotes
    
    [DataManager loadNotes:^(NSArray *notes) {
       
        
    } fromContainerName:self.ownContainer.name];
    
    
    
    // loadimage
    

    /*
    [ParseData loadImageWithContainerName:self.ownContainer.name success:^(NSArray *arrayFile) {
        NSMutableArray *arrImages = [NSMutableArray new];
        for (YPImage *sImage  in arrayFile) {
            [arrImages addObject:sImage.fileData];
        }
        for (int i = 0; i < arrImages.count; i++) {
            if (i<self.images.count) {
                if ([self.imageViewTest isKindOfClass:[PFImageView class]]) {
                    PFImageView *imageViewpt = (PFImageView *)[self.images objectAtIndex:i];
                    imageViewpt.contentMode = UIViewContentModeScaleAspectFit;
                    imageViewpt.file = (PFFile *)arrImages[i];
                    [imageViewpt loadInBackground];
                }
            }
        }
    } error:^{
        
    }];*/
    [DataManager loadContacts:^(NSArray *contacts) {
    
    
    } fromContainerName:self.ownContainer.name];
    
    [self loadImages];
   
}
-(void)resettingFrames
{
    int maxWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    self.mapView.frame = CGRectMake(0, 0, maxWidth, self.mapView.bounds.size.height);
    self.containerNameView.frame = CGRectMake(self.containerNameView.frame.origin.x, self.containerNameView.frame.origin.y,maxWidth, self.containerNameView.frame.size.height);
    self.containerNameView.autoresizesSubviews = YES;
}

-(void)loadImages
{
    [DataManager loadFastDBImages:^(NSArray *imagesArray) {
        
        NSMutableArray *arrImages = [NSMutableArray new];
        for (YPImage *sImage  in imagesArray) {
            [arrImages addObject:sImage.imageData];
        }
        
        for (int i = 0; i < arrImages.count; i++) {
            if (i<self.images.count) {
                if ([self.imageViewTest_2 isKindOfClass:[BrutalUIImageView class]]) {
                    BrutalUIImageView *imageViewpt = (BrutalUIImageView *)[_images objectAtIndex:i];
                    [imageViewpt setImage:[arrImages objectAtIndex:i]] ;
                    imageViewpt = nil;
                }
            }
        }
        _images = nil;
        _imageViewTest_2 = nil;
        _imageViewTest_3 = nil;
    } fromContainerName:self.ownContainer.name];

}


#pragma mark - save actions -
-(void)savePhoto:(id)sender
{
    NSLog(@"moment container name : %@",self.ownContainer.placeName);
    [[FileUploaderManager sharedClass] newImageFromController:self.ptMainController andDelegate:self];

}
-(void)saveNote:(id)sender
{
    Note *customNote = [[Note alloc]init];
    customNote.content = @"testo di prova per vedere se va";
    customNote.containerName = self.ownContainer.name;
    customNote.title = @"titolo di prova";
    
    [DataManager saveNote:customNote inPlace:[[self updatePlace] validatePlace] completionDBBlock:^{
        NSLog(@"nota + momento salvato in locale");
        [self.ptMainController loadRegionsWithFinalBlock:^{
            [self.ptMainController loadContainers];
            
        }];
    } remoteCompletionBlock:^{
        NSLog(@"nota + momento salvato in remoto");
    } remoteFailureBlock:^{
        NSLog(@"qualcosa è andato storto in remoto");

    }];
}
-(void)saveContact:(id)sender
{
    Contact *testContact = [Contact new];
    testContact.name = @"Jacopo_2";
    testContact.tel = @"332325234";
    testContact.containerName = self.ownContainer.name;
    
    [DataManager saveContact:testContact inPlace:[[self updatePlace] validatePlace] completionDBBlock:^{
        NSLog(@"contatto salvato nel db");
    } remoteCompletionBlock:^{
        
    } remoteFailureBlock:^{
        
    }];
}

#pragma mark - support functions -
-(Place *)updatePlace
{
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;

    return [mainController getCurrentPlace];
    
}
-(void)didUploadFileData:(NSData *)dataFile
{
    
    NSDictionary * dictData = @{@"name":kDefaultMomentName,
                                @"contName":self.ownContainer.name,
                                };
    
    NSString *imageUUID = [Utils createUUID];
    [DataManager saveImage:dataFile inPlace:[[self updatePlace] validatePlace]  withData:dictData imageUUID:imageUUID completionDBBlock:^(Moment *mom){
        
        [self.ptMainController loadRegionsWithFinalBlock:^{
            [self.ptMainController loadContainers];
            
        }];
    } remoteCompletionBlock:^(Moment *mom){
        
        [ParseData uploadImageWithData:dataFile imageUUID:imageUUID andMoment:mom success:^{
            NSLog(@"photo uploaded");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Foto caricata " message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        } error:^{
            NSLog(@"error");
        }];
        
    } remoteFailureBlock:^{
        
    }];
}
-(void)dealloc
{
    self.delegate =  nil;
    
    for (UIView *view in self.subviews) {
        for (UIView *sub in view.subviews) {
            [sub removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    self.mapView.delegate = nil;

    self.images = nil;
    self.ptMainController = nil;
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

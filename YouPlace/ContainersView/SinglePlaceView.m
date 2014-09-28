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
#import "PopUp.h"

@interface SinglePlaceView () <MKMapViewDelegate,FileUploaderProtocol,BasePopUpProtocol>

@property (nonatomic,retain) NSArray *images;

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
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
       // self.sonoQui.hidden = YES;
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
    self.containerNameView.layer.shadowOpacity = 0.2;
    self.containerNameView.layer.shadowRadius = 1;
    self.containerNameView.layer.shadowColor = [UIColor blackColor].CGColor;

    self.containerPhotos.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerPhotos.layer.shadowOpacity = 0.2;
    self.containerPhotos.layer.shadowRadius = 1;
    self.containerPhotos.layer.shadowColor = [UIColor blackColor].CGColor;

    self.containerNotes.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerNotes.layer.shadowOpacity = 0.2;
    self.containerNotes.layer.shadowRadius = 1;
    self.containerNotes.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //newMomentButton photos
    self.addPhotosButton.iconImageChar = @"\uf030";
    self.addPhotosButton.mainColor = [ColorConverter colorWithHexString:@"c13f21"];
    self.addPhotosButton.textIconColor = [ColorConverter colorWithHexString:@"ffffff"];
    self.addPhotosButton.textPlusColor = [[ColorConverter colorWithHexString:@"000000"] colorWithAlphaComponent:0.2];
    
    //newMomentButton notes
    self.addNoteButton.iconImageChar = @"\uf0f6";
    self.addNoteButton.mainColor = [ColorConverter colorWithHexString:@"faf396"];
    self.addNoteButton.textIconColor = [ColorConverter colorWithHexString:@"ffffff"];
    self.addNoteButton.textPlusColor = [[ColorConverter colorWithHexString:@"000000"] colorWithAlphaComponent:0.2];
    
    
    if (self.currentPlace) {
      //  self.sonoQui.hidden = NO;
    }
   // else self.sonoQui.hidden = YES;
    
 
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = self.coordinates;
    annotationPoint.title = self.ownContainer.placeName;
    
    
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    region.center = self.coordinates;
    span.latitudeDelta =  0.020;
    span.longitudeDelta =  0.020;
    region.span=span;
    self.mapView.alpha = 0.5;
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView addAnnotation:annotationPoint];
    
    annotationPoint = nil;
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap)];
    [self.mapView addGestureRecognizer:tapMap];
    tapMap = nil;

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
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;

    PopUp *photoPopUp = [[PopUp alloc]initInController:mainController type:@"photo_pop_up" message:@"ciao" andTitle:@"ciao"];
    photoPopUp.openingAnimationName = @"scale";
    photoPopUp.endingAnimationName = @"scale";
    photoPopUp.delegate = self;
    
    
    
    
    [photoPopUp show];
    /*
    
      NSLog(@"moment container name : %@",self.ownContainer.placeName);
    [[FileUploaderManager sharedClass] newImageFromController:mainController andDelegate:self];
*/
}
-(void)closePopUp:(BasePopUp *)popUp
{
    
    PopUp *popUpRenderer = (PopUp *)popUp.renderer;
    [popUpRenderer close];
}
-(void)saveNote:(id)sender
{
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
     MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;

    //tmp
    PopUp *notePopUp = [[PopUp alloc]initInController:mainController type:@"note_pop_up" message:@"ciao" andTitle:@"ciao"];
    notePopUp.openingAnimationName = @"scale";
    notePopUp.endingAnimationName = @"scale";
    notePopUp.delegate = self;
    [notePopUp show];
    /*

    
    Note *customNote = [[Note alloc]init];
    customNote.content = @"testo di prova per vedere se va";
    customNote.containerName = self.ownContainer.name;
    customNote.title = @"titolo di prova";
    
    [DataManager saveNote:customNote inPlace:[[self updatePlace] validatePlace] completionDBBlock:^{
        NSLog(@"nota + momento salvato in locale");
        [mainController loadRegionsWithFinalBlock:^{
            [mainController loadContainers];
            
        }];
    } remoteCompletionBlock:^{
        NSLog(@"nota + momento salvato in remoto");
    } remoteFailureBlock:^{
        NSLog(@"qualcosa è andato storto in remoto");

    }];*/
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
    
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;

    NSDictionary * dictData = @{@"name":kDefaultMomentName,
                                @"contName":self.ownContainer.name,
                                };
    
    NSString *imageUUID = [Utils createUUID];
    [DataManager saveImage:dataFile inPlace:[[self updatePlace] validatePlace]  withData:dictData imageUUID:imageUUID completionDBBlock:^(Moment *mom){
        
        [mainController loadRegionsWithFinalBlock:^{
            [mainController loadContainers];
            
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
    self.containerView =nil;
    for (UIView *view in self.subviews) {
        for (UIView *sub in view.subviews) {
            for (UIView *subs in sub.subviews) {
                [subs removeFromSuperview];
            }
            [sub removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    self.mapView.delegate = nil;

    self.images = nil;
    
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

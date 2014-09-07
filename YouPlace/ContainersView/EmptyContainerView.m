//
//  EmptyContainerView.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "EmptyContainerView.h"
#import "PlaceScroller.h"
#import "MainViewController.h"
#import "Moment.h"
#import "ParseData.h"
#import "Utils.h"

@interface EmptyContainerView()<UITextFieldDelegate>

@property (nonatomic,strong) MainViewController *ptMainController;

@end
@implementation EmptyContainerView

+ (EmptyContainerView *)loadSingleEmptyView
{
    EmptyContainerView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;
    self.ptMainController = mainController;
    self.containerTextField.delegate = self;
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
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)savePhotoForContainer:(id)sender
{
    if (self.containerTextField.text.length) {

        [[FileUploaderManager sharedClass] newImageFromController:self.ptMainController andDelegate:self];
    }
        else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Dai un nome al container" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
}
-(void)didUploadFileData:(NSData *)dataFile
{
    if (self.containerTextField.text.length) {
  
    NSDictionary * dictData = @{
                                @"contName":self.containerTextField.text,
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
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Dai un nome al container" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
-(Place *)updatePlace
{
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;
    return [mainController getCurrentPlace];
}


-(void)saveMomentForContainer:(id)sender{
    /*
    [self saveCurrentMomentInPlace:[self updatePlace] withFinal:^(Moment *moment) {
        
        NSLog(@"OK");
        
        [self.ptMainController loadRegionsWithFinalBlock:^{
            
            [self.ptMainController loadContainers];
        }];
    } errorBlock:^{
        
    }];
     */
}

-(void)saveNoteForContainer:(id)sender
{
    
    NSDictionary * dictData = @{
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
-(Place *)completePlace:(Place *)incompletePlace
{
    if (self.containerTextField.text.length ) {
        
        if (incompletePlace.lat && incompletePlace.lng && incompletePlace.uniqueid) {
            incompletePlace.name = @"default_place_name"; // fix this in future
            incompletePlace.regionRadius = 50;
            return incompletePlace;
            
        }else
        {
            NSLog(@"place without lat / lng or uniqueid");
            return nil;
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Riempi il container" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
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

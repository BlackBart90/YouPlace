//
//  EmptyPlaceView.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "EmptyPlaceView.h"
#import "MainViewController.h"
#import "Place.h"
#import "Moment.h"
#import "Utils.h"
#import "ParseData.h"

@interface EmptyPlaceView()<UITextFieldDelegate>
@property (nonatomic,strong) MainViewController *ptMainController;

@end
@implementation EmptyPlaceView


+ (EmptyPlaceView *)loadSingleEmptyView
{
    EmptyPlaceView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
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
    self.placeTextField.delegate = self;
    self.radiusTextField.delegate = self;
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
    
    NSLog(@"texts :%@  %@" ,self.placeTextField.text,self.radiusTextField.text);
}

-(void)saveMoment:(id)sender
{
    [self saveCurrentMomentInPlace:[self updatePlace] withFinal:^(Moment *moment) {
        
        NSLog(@"OK");
        
        [self.ptMainController loadRegionsWithFinalBlock:^{
            
            [self.ptMainController loadContainers];
        }];
    } errorBlock:^{
        
    }];
    
}
-(Place *)completePlace:(Place *)incompletePlace
{
    if (self.placeTextField.text.length  && self.radiusTextField.text.length) {

    if (incompletePlace.lat && incompletePlace.lng && incompletePlace.uniqueid) {
        incompletePlace.name = self.placeTextField.text;
        incompletePlace.regionRadius = (int)[self.radiusTextField.text integerValue];
        return incompletePlace;
        
    }else
    {
        NSLog(@"place without lat / lng or uniqueid");
        return nil;
    }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Riempi entrambi campi" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
}

#pragma mark - save moment actions -
-(void)saveCurrentMomentInPlace:(Place *)place withFinal:(void(^)(Moment *moment))finalBlock errorBlock:(void(^)(void))error
{
    place = [self completePlace:place];
    
    if (place) {
        
        if (self.placeTextField.text.length  && self.radiusTextField.text.length) {
            
            Moment *newMoment = [[Moment alloc]init];
            newMoment.place = place;
            newMoment.name = @"default_moment_name";
            newMoment.uniqueid = [Utils createUUID];
            newMoment.containerName = place.name;
            newMoment.info  = @{@"key":@"value"};
            newMoment.startDate =[NSDate date];
            newMoment.endDate = [NSDate date];
            
            [ParseData saveNewMoment:newMoment inNewPlace:place success:^{
                NSLog(@"momento %@ salvato",newMoment.uniqueid);
                finalBlock(newMoment);
            } failure:^{
                error();
                NSLog(@"moment non salvato");
            }];
            
        }
    }
}


-(Place *)updatePlace
{
    UIView *view = self.superview.superview;
    PlaceScroller *ptPlaceScroller = (PlaceScroller *) view;
    MainViewController *mainController = (MainViewController *) ptPlaceScroller.superview.nextResponder;
    return [mainController getCurrentPlace];
}

#pragma mark - save photos -

-(void)savePhoto:(id)sender
{
    [[FileUploaderManager sharedClass] newImageFromController:self.ptMainController andDelegate:self];

}
-(void)didUploadFileData:(NSData *)dataFile
{
    [self saveCurrentMomentInPlace:[self updatePlace] withFinal:^(Moment *moment){
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

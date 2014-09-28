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
#import "DataManager.h"
#import "Tree.h"

@interface EmptyContainerView()<UITextFieldDelegate>

@property (nonatomic,strong) MainViewController *ptMainController;

@end
@implementation EmptyContainerView

+ (EmptyContainerView *)loadSingleEmptyView
{
    EmptyContainerView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    return view;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [ManagerTrees addTreesToView:self rectBigTree:CGRectMake(-30, -30, 200, 600) smallTree:CGRectMake(120,350 , 80, 240) andAlpha:1];
    }
    return self;
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
    self.containerView.layer.cornerRadius = 0;
//    
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowRadius = 0.7;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.autoresizesSubviews = YES;
 
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - save actions -
-(void)savePhotoForContainer:(id)sender
{
    if (self.containerTextField.text.length) {
        [[FileUploaderManager sharedClass] newImageFromController:self.ptMainController andDelegate:self];
 
    }
    else
    {
        UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"name empty" message:@"fill the container name" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertMessage show];
    }
}
-(void)saveNoteForContainer:(id)sender
{

    if (self.containerTextField.text.length) {

    Note *customNote = [[Note alloc]init];
    customNote.content = @"nota di prova per vedere se va";
    customNote.containerName = self.containerTextField.text;
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
    else
    {
        UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"name empty" message:@"fill the container name" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertMessage show];
    }
}
-(void)saveContactForContainer:(id)sender
{
    if (self.containerTextField.text.length) {

    Contact *testContact = [Contact new];
    testContact.name = @"Jacopo_2";
    testContact.tel = @"332325234";
    testContact.containerName = self.containerTextField.text;
    
    [DataManager saveContact:testContact inPlace:[[self updatePlace] validatePlace] completionDBBlock:^{
        NSLog(@"contatto salvato nel db");
    } remoteCompletionBlock:^{
        
    } remoteFailureBlock:^{
        
    }];
    }
    else
    {
        UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"name empty" message:@"fill the container name" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertMessage show];
    }
}

#pragma mark - support functions -
-(void)didUploadFileData:(NSData *)dataFile
{
    
    NSDictionary * dictData = @{
                                @"contName":self.containerTextField.text,
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

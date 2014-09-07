//
//  EmptyContainerView.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TappedView.h"
@interface EmptyContainerView : TappedView

+ (EmptyContainerView *)loadSingleEmptyView;

@property (nonatomic,weak) IBOutlet UITextField *containerTextField;
@property (nonatomic,weak) IBOutlet UIView *containerView;



-(IBAction)saveMomentForContainer:(id)sender;
-(IBAction)savePhotoForContainer:(id)sender;
-(IBAction)saveNoteForContainer:(id)sender;
@end

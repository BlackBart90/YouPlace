//
//  EmptyPlaceView.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TappedView.h"

@interface EmptyPlaceView : UIView


+ (EmptyPlaceView *)loadSingleEmptyView;

@property (nonatomic,weak) IBOutlet UITextField *placeTextField;
@property (nonatomic,weak) IBOutlet UITextField *radiusTextField;

@property (nonatomic,weak) IBOutlet UIView *containerView;

-(IBAction)saveMoment:(id)sender;
-(IBAction)savePhoto:(id)sender;
@end

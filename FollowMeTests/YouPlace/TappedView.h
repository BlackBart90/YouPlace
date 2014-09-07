//
//  TappedView.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 29/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TappedView;
@protocol TappedViewProtocol <NSObject>

-(void)tappedView:(TappedView *)tapView;

@end

@interface TappedView : UIView


@property (nonatomic,weak) id <TappedViewProtocol> tapdelegate;
@end

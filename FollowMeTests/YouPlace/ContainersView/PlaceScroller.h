//
//  PlaceScroller.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePlaceView.h"
@class PlaceScroller;

@protocol PlaceScrollerProtocol <NSObject>

//-(void)addItem:(id)item toScroller:(PlaceScroller *)scroller;
- (void)tapMapInView:(SinglePlaceView *)singlePlaceView;
- (void)tapView:(SinglePlaceView *)singlePlaceView;


@end

@interface PlaceScroller : UIScrollView

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,weak) id  <PlaceScrollerProtocol> delegateScroller;

- (id)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource;
- (void)addItem;
- (void)removeItem;
- (void)reloadData;
-(void)scrollToItemFromMomentContainer:(MomentContainer *)momContainer scrollToFirst:(BOOL)scrollToFirst;
- (MomentContainer *)getCurrentMomentContainer;

@end

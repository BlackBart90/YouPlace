//
//  PlaceScroller.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "PlaceScroller.h"
#import "MomentsManager.h"
#import "MomentContainer.h"
#import "EmptyPlaceView.h"
#import "EmptyContainerView.h"

@interface PlaceScroller()<PlaceViewProtocol,UIScrollViewDelegate,TappedViewProtocol>

@property (nonatomic,strong) NSMutableArray *viewsDataSource;
@property (nonatomic,strong) MomentContainer *currentMomentContainer;


@end


@implementation PlaceScroller
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)viewsDataSource
{
    if (!_viewsDataSource) {
        _viewsDataSource = [[NSMutableArray alloc]init];
    }
    return _viewsDataSource;
}
- (id)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self.dataSource setArray:dataSource];
        
        self.backgroundColor = [UIColor clearColor];
        [self configureScroller];
       
        // Initialization code
    }
    return self;
}
- (void)configureScroller
{
    [self removeAll];
    int items_number = (int)self.dataSource.count;// 1 = empty view
    
    for (int i = 1; i <= items_number ; i++) {
        UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        singleView.backgroundColor = [UIColor clearColor];
        [self addSubview:singleView];
        [self.viewsDataSource addObject:singleView];
    }

    self.contentSize = CGSizeMake((items_number+1) * self.bounds.size.width, self.bounds.size.height);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    [self createSubviews];
    
}
- (void)createSubviews
{
    int internalMargin = 5;
    
    for (int i = 0; i < self.viewsDataSource.count; i++) {
        UIView *subView = [self.viewsDataSource objectAtIndex:i];
        int subview_width = subView.bounds.size.width;
        int subview_height = subView.bounds.size.height;
        SinglePlaceView *placeView = [SinglePlaceView loadSinglePlaceView];
        placeView.delegate = self;
        placeView.tapdelegate = self;
        MomentContainer *container = [self.dataSource objectAtIndex:i];

        placeView.ownContainer = container;
        
//        if (placeView.currentPlace) {
//            currentView = placeView;
//        }
        
        placeView.frame = CGRectMake(internalMargin, internalMargin, subview_width-internalMargin*2, subview_height-internalMargin*2);
        [subView addSubview:placeView];
    }
    [self addingEmptyContainer];

}
// not used
-(void)addingEmptyPlace
{
    UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, self.bounds.size.width, self.bounds.size.height)];
    singleView.backgroundColor = [UIColor clearColor];
    [self addSubview:singleView];
    
    EmptyPlaceView *emptyView = [EmptyPlaceView loadSingleEmptyView];
    int internalMargin = 5;
    
    emptyView.frame = CGRectMake(internalMargin, internalMargin, singleView.bounds.size.width-internalMargin*2, singleView.bounds.size.height-internalMargin*2);
    [singleView addSubview:emptyView];
}
-(void)addingEmptyContainer
{
    UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    singleView.backgroundColor = [UIColor clearColor];
    [self addSubview:singleView];
    
    EmptyContainerView *emptyView = [EmptyContainerView loadSingleEmptyView];
    emptyView.tapdelegate = self;
    int internalMargin = 5;
    
    emptyView.frame = CGRectMake(internalMargin, internalMargin, singleView.bounds.size.width-internalMargin*2, singleView.bounds.size.height-internalMargin*2);
    [singleView addSubview:emptyView];
}
-(void)didTapMapInView:(SinglePlaceView *)placeView
{
    [self.delegateScroller tapMapInView:placeView];
}
-(void)tappedView:(TappedView *)tapView
{
    if ([tapView isKindOfClass:[SinglePlaceView class]]) {
        SinglePlaceView *singleTappedView = (SinglePlaceView *)tapView;
        [self.delegateScroller tapView:singleTappedView];
    }
}
-(void)scrollToItem:(SinglePlaceView *)placeView
{
    UIView *parentView = placeView.superview;

    [UIView animateWithDuration:0.4 animations:^{
        [self scrollRectToVisible:parentView.frame animated:NO];

    } completion:^(BOOL finished) {
        [self setIstanceToCurrentMomentContainerFromScrollView:self];
    }];
    
}
-(void)scrollToItemFromMomentContainer:(MomentContainer *)momContainer scrollToFirst:(BOOL)scrollToFirst
{
    if (scrollToFirst) {
        if (self.contentOffset.x != 0 ) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }else{
    SinglePlaceView *currentView;
    for (UIView *sPlace in self.viewsDataSource) {
        NSArray* subViews = sPlace.subviews;
        if (subViews.count > 0) {
        
        if ([[subViews objectAtIndex:0] isKindOfClass:[SinglePlaceView class]]) {
            SinglePlaceView *singlePlace = [subViews objectAtIndex:0];
            if ([singlePlace.ownContainer isEqualToMomentContainer:momContainer]) {
                currentView = singlePlace;
            }
        }
        }
    }
    if (currentView) {
        [self scrollToItem:currentView];
    }
    }
}

-(void)removeAll
{
    for (UIView *subView in self.subviews) {
        for (UIView *subsubView in subView.subviews) {
            [subsubView removeFromSuperview];
        }
        [subView removeFromSuperview];
    }
    [self.viewsDataSource removeAllObjects];
}
-(void)reloadData
{
    [self configureScroller];

}
-(void)addItem
{
    [self.dataSource addObject:[UIView new]];
    [self configureScroller];
}
-(void)removeItem
{
    if (self.dataSource.count>0) {
        [self.dataSource removeLastObject];
        [self configureScroller];
    }
}
-(MomentContainer *)getCurrentMomentContainer
{
    return self.currentMomentContainer;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self setIstanceToCurrentMomentContainerFromScrollView:scrollView];

}
-(void)setIstanceToCurrentMomentContainerFromScrollView:(UIScrollView *)scrollView
{
    int page = (self.contentOffset.x / self.bounds.size.width);
    if (page > 0) {
        self.currentMomentContainer = [self.dataSource objectAtIndex:page-1];
    }else
        self.currentMomentContainer = nil;
    
    NSLog(@"current  : %@",self.currentMomentContainer.name);
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

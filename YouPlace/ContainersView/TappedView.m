//
//  TappedView.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 29/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "TappedView.h"

@implementation TappedView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapView)];
        [self addGestureRecognizer:tapGesture];
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
-(void)tapView
{
    [self.tapdelegate tappedView:self];
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

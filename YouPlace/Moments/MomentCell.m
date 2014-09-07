//
//  MomentCell.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 13/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MomentCell.h"

@implementation MomentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.title = [[UILabel alloc]initWithFrame:self.bounds];
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];
        // Initialization code
    }
    return self;
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

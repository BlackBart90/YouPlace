//
//  MIABasePopUp.m
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIABasePopUp.h"
#import "MIAPopUpFactory.h"

@implementation MIABasePopUp

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
-(void)loadCustomArgs:(NSDictionary *)dictionaryArgs{}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  PhotoPopUp.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 22/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "PhotoPopUp.h"
#import "ColorConverter.h"

@implementation PhotoPopUp

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    AwesomeButton *closeButton = [[AwesomeButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-50, 5, 50, 50)];
    closeButton.ownCode = @"\uf00d";
    closeButton.fontCodeColor = [ColorConverter colorWithHexString:@"ffffff"];
    
    [closeButton addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
}
-(void)closePopUp
{
    [self.delegate closePopUp:self];
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

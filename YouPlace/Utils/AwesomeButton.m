//
//  AwesomeButton.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 28/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "AwesomeButton.h"
@interface AwesomeButton()



@end
@implementation AwesomeButton
-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        [self innerInit];

        // Initialization code
    }
    return self;
   
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self innerInit];
    }
    return self;
}


-(void)innerInit
{
    self.ownTitle = nil;
    self.ownCode = nil;
    self.ownCodeSize = 20;
    self.ownTitleSize = 20;
    self.fontCodeColor = [UIColor blackColor];
    self.titleColor = [UIColor blackColor];
    self.titleFontName = @"Helvetica Neue";
    self.fontCodeName = @"FontAwesome";
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.ownCode.length || self.ownTitle.length) {
        [self addData];
    }
}
-(void)addData
{
    //INFORMAZIONI
    if (self.ownCode && self.ownTitle) {
    
    NSString *info = self.ownTitle;
    NSString *icon_info = self.ownCode;
    NSString *info_string = [NSString stringWithFormat:@"%@   %@",icon_info ,info];
    NSMutableAttributedString *attributedString_info = [[NSMutableAttributedString alloc]initWithString:info_string];
    
    [attributedString_info addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.fontCodeName size:self.ownCodeSize] range:NSMakeRange(0,1)];
    [attributedString_info addAttribute:NSForegroundColorAttributeName value:self.fontCodeColor range:NSMakeRange(0,1)];
    [attributedString_info addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.titleFontName size:self.ownTitleSize] range:NSMakeRange(icon_info.length+3, info.length)];
    [attributedString_info addAttribute:NSForegroundColorAttributeName value:self.titleColor range:NSMakeRange(icon_info.length+3, info.length)];
    
    [self setAttributedTitle:attributedString_info forState:UIControlStateNormal];
        
    }
    
    if (self.ownCode && !self.ownTitle) {
        self.titleLabel.font = [UIFont fontWithName:self.fontCodeName size:20];
        self.titleLabel.textColor = self.fontCodeColor;
        [self setTitle:self.ownCode forState:UIControlStateNormal];
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        
        self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }else
    {
        self.transform = CGAffineTransformIdentity;

    }
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

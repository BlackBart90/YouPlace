//
//  NewMomentButton.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 20/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "NewMomentButton.h"
@interface NewMomentButton()

@property (nonatomic,strong) UILabel *iconLabel;
@property (nonatomic,strong) UILabel *plusLabel;



@end

@implementation NewMomentButton
-(void)setTextIconColor:(UIColor *)textIconColor
{
    self.iconLabel.textColor = textIconColor;
}
-(void)setTextPlusColor:(UIColor *)textPlusColor
{
    self.plusLabel.textColor = textPlusColor;
}
-(void)setIconImageChar:(NSString *)iconImageChar
{
    self.iconLabel.text = iconImageChar;
}
-(void)setMainColor:(UIColor *)mainColor
{
    self.backgroundColor = mainColor;
    _mainColor = mainColor;
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
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self innerInit];
    }
    return self;
}
- (void)innerInit
{
    CGSize sizeButton = CGSizeMake(30, 30);
    self.iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, self.bounds.size.height-sizeButton.width, sizeButton.width, sizeButton.height)];
    self.iconLabel.font = [UIFont fontWithName:@"FontAwesome" size:22];
    self.iconLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: self.iconLabel];
    
    CGSize sizePlus = CGSizeMake(20, 20);

    self.plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-sizePlus.width+3, 5, sizePlus.width, sizePlus.height)];
     self.plusLabel.text = @"+";
     self.plusLabel.textColor = [UIColor blackColor];
     self.plusLabel.font = [UIFont fontWithName:@"Avenir-Light" size:25];
    [self addSubview: self.plusLabel];
    
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [self.mainColor colorWithAlphaComponent:0.7];
    }else
    {
        self.backgroundColor = self.mainColor;
    }
    [super setHighlighted:highlighted];

}
- (void)dealloc
{
    self.plusLabel = nil;
    self.iconImageChar = nil;
    self.iconLabel = nil;
    self.mainColor = nil;
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

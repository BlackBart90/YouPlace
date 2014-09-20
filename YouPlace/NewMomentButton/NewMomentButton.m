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
-(void)setTextColor:(UIColor *)textColor
{
    self.iconLabel.textColor = textColor;
    self.plusLabel.textColor = textColor;
}
-(void)setIconImageChar:(NSString *)iconImageChar
{
    self.iconLabel.text = iconImageChar;
}
-(void)setMainColor:(UIColor *)mainColor
{
    self.backgroundColor = mainColor;
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
    self.iconLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    self.iconLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: self.iconLabel];
    
    CGSize sizePlus = CGSizeMake(20, 20);

    self.plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-sizePlus.width, 5, sizePlus.width, sizePlus.height)];
     self.plusLabel.text = @"+";
     self.plusLabel.textColor = [UIColor blackColor];
     self.plusLabel.font = [UIFont italicSystemFontOfSize:30];
    [self addSubview: self.plusLabel];
    
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

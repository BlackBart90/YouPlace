//
//  NotePopUp.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 22/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "NotePopUp.h"
#import "AwesomeButton.h"
#import "ColorConverter.h"
#import "Tree.h"

@implementation NotePopUp

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
        AwesomeButton *closeButton = [[AwesomeButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-50, 5, 50, 50)];
        closeButton.ownCode = @"\uf00d";
        closeButton.fontCodeColor = [ColorConverter colorWithHexString:@"ffffff"];
        
        [closeButton addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        self.layer.masksToBounds = YES;
        [ManagerTrees addTreesToView:self rectBigTree:CGRectMake(-30, -40, 200, 600) smallTree:CGRectMake(120,150 , 80, 240) andAlpha:0.2];
        

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
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

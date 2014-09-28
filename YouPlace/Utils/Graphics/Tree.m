//
//  Tree.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 27/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Tree.h"
#import "ColorConverter.h"

@implementation Tree

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // draw shadow
        int translating_x = 30;
        int translating_y = 30;
        [self drawTrunkShadowFromHeight:[self drawFoliageShadowFromHeight:0 withXTranslating:translating_x andYTranslating:translating_y] withXTranslating:translating_x andYTranslating:translating_y+0.5];
        
        [self drawTrunkFromHeight:[self drawFoliageFromHeight:0]-5];
        
       
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(int)drawFoliageFromHeight:(int)originY
{
    CGRect mainFrame = self.bounds;
    float scale = 3.2;
    int height = mainFrame.size.height/scale;
    
    UIView *foliage = [[UIView alloc]initWithFrame:CGRectMake(mainFrame.origin.x, originY, mainFrame.size.width, mainFrame.size.height/scale)];
    
    foliage.layer.cornerRadius = height/2;
    foliage.layer.masksToBounds = YES;
    foliage.backgroundColor = [ColorConverter colorWithHexString:@"4fe691"];
    [self addSubview:foliage];
    return height;
}
-(int)drawTrunkFromHeight:(int)originY
{
    CGRect mainFrame = self.bounds;
    int height = mainFrame.size.height - originY;
    int width = mainFrame.size.width/7;
    int originX = (mainFrame.size.width-width)/2;
    UIView *trunk = [[UIView alloc]initWithFrame:CGRectMake(originX,originY,width, height)];
    trunk.backgroundColor = [UIColor whiteColor];
    [self addSubview:trunk];
    return height;
}

-(int)drawFoliageShadowFromHeight:(int)originY withXTranslating:(int)xt andYTranslating:(int)yt{
    CGRect mainFrame = self.bounds;
    float scale = 3.2;
    int height = mainFrame.size.height/scale;
    
    UIView *foliage = [[UIView alloc]initWithFrame:CGRectMake(mainFrame.origin.x+xt, originY+yt, mainFrame.size.width, mainFrame.size.height/scale)];
    
    foliage.layer.cornerRadius = height/2;
    foliage.layer.masksToBounds = YES;
    foliage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:foliage];
    
    return height;
}
-(int)drawTrunkShadowFromHeight:(int)originY   withXTranslating:(int)xt andYTranslating:(int)yt
{
    CGRect mainFrame = self.bounds;
    int height = mainFrame.size.height - originY;
    int width = mainFrame.size.width/7;
    int originX = (mainFrame.size.width-width)/2;
    UIView *trunk = [[UIView alloc]initWithFrame:CGRectMake(originX+xt,originY+yt,width, height)];
    trunk.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:trunk];
    return height;
}
- (void)dealloc
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
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

@implementation ManagerTrees

+(void)addTreesToView:(UIView *)mainView rectBigTree:(CGRect)rectBig smallTree:(CGRect)rectSmall andAlpha:(float)alpha
{
    
    // BIG TREE rectBig
    Tree *bigTree = [[Tree alloc]initWithFrame:rectBig];
    bigTree.alpha = alpha;
    bigTree.transform = CGAffineTransformMakeTranslation(-500, 0);
    [mainView addSubview:bigTree];
    
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        bigTree.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    // SMALL TREE
    Tree *smallTree = [[Tree alloc]initWithFrame:rectSmall];
    smallTree.alpha = alpha;
    smallTree.transform = CGAffineTransformMakeTranslation(-400, 0);
    [mainView addSubview:smallTree];
    
    [UIView animateWithDuration:0.6 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        smallTree.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    

}

@end

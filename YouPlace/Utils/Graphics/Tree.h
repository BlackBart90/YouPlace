//
//  Tree.h
//  YouPlace
//
//  Created by Jacopo Pappalettera on 27/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tree : UIView

@end

@interface ManagerTrees : NSObject
+(void)addTreesToView:(UIView *)mainView rectBigTree:(CGRect)rectBig smallTree:(CGRect)rectSmall andAlpha:(float)alpha;

@end

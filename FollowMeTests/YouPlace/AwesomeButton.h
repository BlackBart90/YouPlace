//
//  AwesomeButton.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 28/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwesomeButton : UIButton
@property (nonatomic,strong) UIColor *fontCodeColor;
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) NSString *fontCodeName;
@property (nonatomic,strong) NSString *titleFontName;

@property (nonatomic,strong) NSString *ownTitle;
@property (nonatomic,strong) NSString *ownCode;
@property (nonatomic,assign) CGFloat ownTitleSize;
@property (nonatomic,assign) CGFloat ownCodeSize;

@end

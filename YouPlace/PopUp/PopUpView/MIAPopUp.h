//
//  MIAPopUp.h
//  FwkTest
//
//  Created by Jacopo on 04/08/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIABasePopUp.h"

@interface MIAPopUp : NSObject

- (instancetype)initInController:(UIViewController *)controller type:(NSString *)type message:(NSString *)message andTitle:(NSString *)title;
- (void)show;
- (void)close;

@property (nonatomic,strong) NSString *openingAnimationName;
@property (nonatomic,strong) NSString *endingAnimationName;
@property (nonatomic,weak) id <MIABasePopUpProtocol> delegate;

@end
